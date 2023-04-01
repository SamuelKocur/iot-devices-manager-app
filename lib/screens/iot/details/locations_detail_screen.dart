import 'package:flutter/material.dart';
import 'package:iot_devices_manager_app/widgets/common/custom_input_field.dart';
import 'package:iot_devices_manager_app/widgets/location_card.dart';
import 'package:provider/provider.dart';

import '../../../models/responses/iot/location.dart';
import '../../../providers/location.dart';
import '../../../widgets/common/error_dialog.dart';
import '../../../widgets/device_card.dart';

class LocationDetailScreen extends StatefulWidget {
  static const routeName = '/location-detail';

  LocationDetailScreen({Key? key}) : super(key: key);

  @override
  State<LocationDetailScreen> createState() => _LocationDetailScreenState();
}

class _LocationDetailScreenState extends State<LocationDetailScreen> {
  final TextEditingController _customNameController = TextEditingController();
  late LocationDetail _locationDetail;
  late int _locationId;
  String _customName = "";

  Future<void> _getLocationDetail(BuildContext context) async {
    try {
      _locationDetail = await Provider.of<LocationsData>(context, listen: false).getAndReloadLocationDetailById(_locationId) as LocationDetail;
      _customNameController.text = _locationDetail.location.getCustomNameOrName();
    } catch (error) {
      DialogUtils.showErrorDialog(context, 'Something went wrong when fetching location information. Please try again later.');
    }
  }

  Future<void> _setLocationName(String name) async {
    try {
      await Provider.of<LocationsData>(context, listen: false).setLocationCustomName(_locationId, name);
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
          hintText: _locationDetail.location.name,
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
              _setLocationName('');
              Navigator.of(ctx).pop();
            },
            child: const Text('Reset'),
          ),
          TextButton(
            onPressed: () {
              _setLocationName(_customName);
              Navigator.of(ctx).pop();
            },
            child: const Text('Save'),
          )
        ],
      ),
    );
  }

  Widget _getEmptyScreen() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(_customName),
        actions: const [
          Icon(Icons.edit_outlined),
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
    _locationId = args['id'] as int;
    _customName = args['name'] as String;
    return FutureBuilder(
      future: _getLocationDetail(context),
      builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting
          ? _getEmptyScreen()
          : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text(_locationDetail.location.getCustomNameOrName()),
              actions: [
                IconButton(
                  onPressed: () {
                    _showEditNameDialog();
                  },
                  icon: const Icon(Icons.edit_outlined),
                ),
              ],
            ),
            body: RefreshIndicator(
              onRefresh: () => _getLocationDetail(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Consumer<LocationsData>(
                    builder: (ctx, locationsData, _) => ChangeNotifierProvider.value(
                      value: _locationDetail.location,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),
                        child: LocationCard(isLocationsScreen: true),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 25,
                    ),
                    child: Text(
                      'Sensors:',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  Expanded(
                    child: Consumer<LocationsData>(
                      builder: (ctx, locationsData, _) => ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 5,
                        ),
                        itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
                          value: _locationDetail.sensors[index],
                          child: Padding(
                            padding: const EdgeInsets.only(
                              bottom: 10,
                            ),
                            child: DeviceCard(isLocationsScreen: true),
                          ),
                        ),
                        itemCount: _locationDetail.sensors.length,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
