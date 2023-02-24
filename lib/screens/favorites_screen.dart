import 'package:flutter/material.dart';
import 'package:iot_devices_manager_app/providers/iot.dart';
import 'package:provider/provider.dart';

import '../widgets/common/error_dialog.dart';
import '../widgets/device_card.dart';

class FavoritesScreen extends StatelessWidget {
  static const routeName = '/favorites';

  const FavoritesScreen({Key? key}) : super(key: key);

  Future<void> _refreshFavorites(BuildContext context) async {
    try {
      await Provider.of<IoTDevices>(context, listen: false)
          .fetchAndSetFavoriteIoTDevices();
    } catch (error) {
      DialogUtils.showErrorDialog(
          context, 'Something went wrong. Please try again later.');
    }
  }

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
            'You can save them by clicking hear button.',
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
    return favoriteDevices.isEmpty
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
    // // fetching favorites from server
    // return FutureBuilder(
    //   future: _refreshFavorites(context),
    //   builder: (ctx, snapshot) =>
    //       snapshot.connectionState == ConnectionState.waiting
    //           ? const Center(
    //               child: CircularProgressIndicator(),
    //             )
    //           : RefreshIndicator(
    //               onRefresh: () => _refreshFavorites(context),
    //               child: Consumer<IoTDevices>(
    //                 builder: (ctx, devicesData, _) => ListView.builder(
    //                   padding: const EdgeInsets.symmetric(
    //                     horizontal: 15,
    //                     vertical: 5,
    //                   ),
    //                   itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
    //                     value: devicesData.favoriteSensors[index],
    //                     child: Padding(
    //                       padding: const EdgeInsets.only(
    //                         bottom: 10,
    //                       ),
    //                       child: DeviceCard(),
    //                     ),
    //                   ),
    //                   itemCount: devicesData.favoriteSensors.length,
    //                 ),
    //               ),
    //             ),
    // );
  }
}
