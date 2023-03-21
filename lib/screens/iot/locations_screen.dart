import 'package:flutter/material.dart';
import 'package:iot_devices_manager_app/providers/location.dart';
import 'package:iot_devices_manager_app/widgets/common/no_iot_devices.dart';
import 'package:provider/provider.dart';

import '../../widgets/common/error_dialog.dart';
import '../../widgets/location_card.dart';

class LocationsScreen extends StatelessWidget {
  static const routeName = '/locations';

  const LocationsScreen({Key? key}) : super(key: key);

  Future<void> _refreshLocations(BuildContext context) async {
    try {
      await Provider.of<Locations>(context, listen: false)
          .fetchAndSetLocations();
    } catch (error) {
      DialogUtils.showErrorDialog(
          context, 'Something went wrong when trying to fetch all locations. Please try again later.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _refreshLocations(context),
      builder: (ctx, snapshot) =>
          snapshot.connectionState == ConnectionState.waiting
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : RefreshIndicator(
                  onRefresh: () => _refreshLocations(context),
                  child: Consumer<Locations>(
                    builder: (ctx, locationsData, _) =>
                        locationsData.locations.isEmpty
                            ? const NoAvailableIoTDevicesWidget()
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 10,
                                ),
                                itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
                                  value: locationsData.locations[index],
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 15,
                                    ),
                                    child: LocationCard(),
                                  ),
                                ),
                                itemCount: locationsData.locations.length,
                              ),
                  ),
                ),
    );
  }
}
