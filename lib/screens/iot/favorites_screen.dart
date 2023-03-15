import 'package:flutter/material.dart';
import 'package:iot_devices_manager_app/providers/iot.dart';
import 'package:iot_devices_manager_app/widgets/common/no_iot_devices.dart';
import 'package:provider/provider.dart';

import '../../widgets/device_card.dart';

class FavoritesScreen extends StatelessWidget {
  static const routeName = '/favorites';

  const FavoritesScreen({Key? key}) : super(key: key);

  Widget _noFavoriteDevices(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'You don\'t have any favorite IoT devices.',
            style: Theme.of(context).textTheme.headline5,
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            'You can save them by clicking heart button.',
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // filtering it from all fetched sensors
    final iotData = Provider.of<IoTDevices>(context);
    final favoriteDevices = iotData.favoriteSensors;
    return iotData.sensors.isEmpty
        ? const NoAvailableIoTDevicesWidget()
        : favoriteDevices.isEmpty
            ? _noFavoriteDevices(context)
            : ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 5,
                ),
                itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
                  value: favoriteDevices[index],
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 10,
                    ),
                    child: DeviceCard(),
                  ),
                ),
                itemCount: favoriteDevices.length,
              );
  }
}
