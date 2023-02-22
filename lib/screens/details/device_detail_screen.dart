import 'package:flutter/material.dart';
import 'package:iot_devices_manager_app/widgets/device_card.dart';
import 'package:provider/provider.dart';

import '../../providers/iot.dart';
import '../../widgets/common/error_dialog.dart';

class DeviceDetailScreen extends StatelessWidget {
  static const routeName = '/device-detail';

  const DeviceDetailScreen({Key? key}) : super(key: key);

  Future<void> _getDeviceDetail(BuildContext context, int sensorId) async {
    try {
      await Provider.of<IoTDevices>(context, listen: false)
          .getAndReloadSensorById(sensorId);
    } catch (error) {
      DialogUtils.showErrorDialog(
          context, 'Something went wrong. Please try again later.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final sensorId = ModalRoute.of(context)!.settings.arguments as int;
    final sensorData = Provider.of<IoTDevices>(
      context,
      listen: false,
    );
    final sensor = sensorData.getSensorById(sensorId);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(sensor.name ?? sensor.type),
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
            builder: (context, deviceData, _) => IconButton(
              enableFeedback: false,
              onPressed: () => Provider.of<IoTDevices>(context, listen: false)
                  .toggleFavoriteSensors(sensor),
              icon: Icon(
                sensor.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: sensor.isFavorite ? Colors.pink : Colors.black,
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder(
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
                    Consumer<IoTDevices>(
                      builder: (ctx, devicesData, _) => ChangeNotifierProvider.value(
                        value: sensor,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 10,
                          ),
                          child: DeviceCard(isLocationsScreen: true),
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
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
