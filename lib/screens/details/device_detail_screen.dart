import 'package:flutter/material.dart';
import 'package:iot_devices_manager_app/models/data_filtering.dart';
import 'package:iot_devices_manager_app/themes/light/text_theme.dart';
import 'package:iot_devices_manager_app/widgets/device_detail/data_filtering_widget.dart';
import 'package:provider/provider.dart';

import '../../models/device_types.dart';
import '../../models/responses/iot.dart';
import '../../providers/iot.dart';
import '../../widgets/common/error_dialog.dart';
import 'locations_detail_screen.dart';

class DeviceDetailScreen extends StatefulWidget {
  static const routeName = '/device-detail';

  const DeviceDetailScreen({Key? key}) : super(key: key);

  @override
  State<DeviceDetailScreen> createState() => _DeviceDetailScreenState();
}

class _DeviceDetailScreenState extends State<DeviceDetailScreen> {
  Sensor? _sensor;

  Future<void> _getDeviceDetail(BuildContext context, int sensorId) async {
    try {
      final updatedSensor =
          await Provider.of<IoTDevices>(context, listen: false)
              .getAndReloadSensorById(sensorId);
      _sensor = updatedSensor;
    } catch (error) {
      DialogUtils.showErrorDialog(
          context, 'Something went wrong. Please try again later.');
    }
  }

  List<DropdownMenuItem<String>> _dataRangeMenu() {
    return DateRangeOptions.values
        .map(
          (e) => DropdownMenuItem(
            value: e.text,
            child: Text(
              e.text,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final sensorId = ModalRoute.of(context)!.settings.arguments as int;
    final iotData = Provider.of<IoTDevices>(
      context,
      listen: false,
    );
    _sensor = iotData.getSensorById(sensorId);
    _getDeviceDetail(context, sensorId);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: _sensor != null
            ? Text(_sensor!.name ?? _sensor!.type)
            : const SizedBox(),
        actions: [
          IconButton(
            onPressed: () {
              // Navigator.of(context).pushNamed(SavedRecipesScreen.routeName); // TODO new screen for comparing
            },
            icon: const Icon(
              Icons.add_circle_outline_rounded,
            ),
          ),
          Consumer<IoTDevices>(
            builder: (ctx, sen, _) => IconButton(
              enableFeedback: false,
              onPressed: () => Provider.of<IoTDevices>(context, listen: false)
                  .toggleFavoriteSensors(_sensor),
              icon: Icon(
                _sensor?.isFavorite ?? false
                    ? Icons.favorite
                    : Icons.favorite_border,
                color:
                    _sensor?.isFavorite ?? false ? Colors.pink : Colors.black,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FutureBuilder(
          future: _getDeviceDetail(context, sensorId),
          builder: (ctx, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : RefreshIndicator(
                  onRefresh: () => _getDeviceDetail(context, sensorId),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            DeviceTypes.values
                                .firstWhere(
                                    (element) => element.text == _sensor!.type,
                                    orElse: () => DeviceTypes.others)
                                .icon,
                            color: Theme.of(context).colorScheme.primary,
                            size: 80,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                _sensor!.getFormattedDate(),
                                style: TextInDetailsScreen.data,
                              ),
                              Text(
                                _sensor!.getFormattedLatestValue(),
                                style: const TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            'Location: ',
                            style: TextInDetailsScreen.data,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                LocationDetailScreen.routeName,
                                arguments: {
                                  'id': _sensor?.device.location.id,
                                  'name': _sensor?.device.location.name,
                                },
                              );
                            },
                            child: Text(
                              _sensor?.device.location.name ?? "",
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          )
                        ],
                      ),
                      FilterDataWidget(sensorId),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
