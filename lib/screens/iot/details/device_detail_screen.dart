import 'package:flutter/material.dart';
import 'package:iot_devices_manager_app/providers/location.dart';
import 'package:iot_devices_manager_app/themes/light/text_theme.dart';
import 'package:iot_devices_manager_app/widgets/device_detail/data_filtering_widget.dart';
import 'package:provider/provider.dart';

import '../../../models/device_types.dart';
import '../../../models/responses/iot/sensor.dart';
import '../../../providers/iot.dart';
import '../../../widgets/common/custom_input_field.dart';
import '../../../widgets/common/error_dialog.dart';
import 'locations_detail_screen.dart';

class DeviceDetailScreen extends StatefulWidget {
  static const routeName = '/device-detail';

  const DeviceDetailScreen({Key? key}) : super(key: key);

  @override
  State<DeviceDetailScreen> createState() => _DeviceDetailScreenState();
}

class _DeviceDetailScreenState extends State<DeviceDetailScreen> {
  final TextEditingController _customNameController = TextEditingController();
  late Sensor _sensor;
  late int _sensorId;
  String _customName = "";

  Future<void> _getDeviceDetail(BuildContext context, int sensorId) async {
    try {
      _sensor = await Provider.of<IoTDevicesData>(context, listen: false).getAndReloadSensorById(sensorId) as Sensor;
      _customNameController.text = _sensor.getCustomNameOrName();
    } catch (error) {
      DialogUtils.showErrorDialog(context,
          'Something went wrong when getting device. Please try again later.');
    }
  }

  Future<void> _setDeviceName(String name) async {
    try {
      await Provider.of<IoTDevicesData>(context, listen: false).setSensorCustomName(_sensor.id, name);
      setState(() {});
    } catch (error) {
      DialogUtils.showErrorDialog(context, 'Something went wrong when changing name. Please try again later.');
    }
  }

  void _showEditNameDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Change location name or reset it to settings name:'),
        content: CustomInputFieldWidget(
          hintText: _sensor.name,
          controller: _customNameController,
          onChanged: (val) {
            _customName = val;
          },
          enabled: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _setDeviceName('');
              Navigator.of(ctx).pop();
            },
            child: const Text('Reset'),
          ),
          TextButton(
            onPressed: () {
              _setDeviceName(_customName);
              Navigator.of(ctx).pop();
            },
            child: const Text('Save'),
          )
        ],
      ),
    );
  }

  List<Widget> _getLatestValueWidget(Sensor sensor, BuildContext context) {
    if (sensor.isBoolSensor()) {
      return [
        const SizedBox(
          height: 10,
        ),
        const Text(
          'Last activity:',
          textAlign: TextAlign.left,
          style: TextInDetailsScreen.data,
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          sensor.getFormattedDate(),
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
          ),
          softWrap: false,
          maxLines: 1,
          overflow: TextOverflow.fade,
        ),
        const SizedBox(
          height: 10,
        ),
      ];
    }
    return [
      Text(
        _sensor.getFormattedDate(),
        style: TextInDetailsScreen.data,
      ),
      Text(
        _sensor.getFormattedLatestValue(),
        style: const TextStyle(
          fontSize: 50,
          fontWeight: FontWeight.w700,
        ),
      ),
    ];
  }

  Widget _getEmptyScreen() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(_customName),
        actions: const [
          IconButton(onPressed: null, icon: Icon(Icons.edit_outlined)),
          IconButton(
              onPressed: null, icon: Icon(Icons.add_circle_outline_rounded)),
          IconButton(onPressed: null, icon: Icon(Icons.favorite_border)),
        ],
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    _sensorId = args['id'] as int;
    _customName = args['name'] as String;
    return FutureBuilder(
      future: _getDeviceDetail(context, _sensorId),
      builder: (ctx, snapshot) => snapshot.connectionState ==
              ConnectionState.waiting
          ? _getEmptyScreen()
          : Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: Text(_sensor.getCustomNameOrName()),
                actions: [
                  IconButton(
                    onPressed: () {
                      _showEditNameDialog();
                    },
                    icon: const Icon(Icons.edit_outlined),
                  ),
                  Consumer<IoTDevicesData>(
                    builder: (ctx, devicesData, _) => IconButton(
                      onPressed: () {
                        if (!devicesData.isSensorSelectedForComparison(_sensorId)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Sensor added to comparison.'),
                              duration: Duration(seconds: 3),
                            ),
                          );
                        }
                        devicesData.toggleSelectedForComparison(_sensorId);
                      },
                      icon: Icon(
                        devicesData.isSensorSelectedForComparison(_sensorId)
                            ? Icons.add_circle
                            : Icons.add_circle_outline_rounded,
                        color: devicesData.isSensorSelectedForComparison(_sensorId)
                            ? Theme.of(context).colorScheme.primary
                            : Colors.black,
                      ),
                    ),
                  ),
                  Consumer<IoTDevicesData>(
                    builder: (ctx, devicesData, _) => IconButton(
                      enableFeedback: false,
                      onPressed: () => Provider.of<IoTDevicesData>(context, listen: false).toggleFavoriteSensors(_sensor.id),
                      icon: Icon(
                        _sensor.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: _sensor.isFavorite
                            ? Colors.pink
                            : Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              body: RefreshIndicator(
                onRefresh: () => _getDeviceDetail(context, _sensorId),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Consumer<IoTDevicesData>(
                      builder: (ctx, devicesData, _) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                DeviceTypes.values
                                    .firstWhere(
                                        (element) => element.text == _sensor.type,
                                        orElse: () => DeviceTypes.others)
                                    .icon,
                                color: Theme.of(context).colorScheme.primary,
                                size: 80,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:
                                    _getLatestValueWidget(_sensor, context),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                'Location: ',
                                style: TextInDetailsScreen.data,
                              ),
                              Consumer<LocationsData>(
                                builder: (ctx, locations, _) => TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(
                                      LocationDetailScreen.routeName,
                                      arguments: {
                                        'id': _sensor.device.location.id,
                                        'name': _sensor.device.location
                                            .getCustomNameOrName(),
                                      },
                                    );
                                  },
                                  child: Text(
                                    _sensor.device.location.getCustomNameOrName(),
                                    style: Theme.of(context).textTheme.headline5,
                                  ),
                                ),
                              )
                            ],
                          ),
                          FilterDataWidget(_sensorId),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
