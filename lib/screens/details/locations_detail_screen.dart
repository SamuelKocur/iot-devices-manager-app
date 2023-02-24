import 'package:flutter/material.dart';
import 'package:iot_devices_manager_app/widgets/location_card.dart';
import 'package:provider/provider.dart';

import '../../providers/location.dart';
import '../../widgets/common/error_dialog.dart';
import '../../widgets/device_card.dart';

class LocationDetailScreen extends StatelessWidget {
  static const routeName = '/location-detail';

  const LocationDetailScreen({Key? key}) : super(key: key);

  Future<void> _getLocationDetail(BuildContext context, int locationId) async {
    try {
      await Provider.of<Locations>(context, listen: false)
          .getLocationById(locationId);
    } catch (error) {
      DialogUtils.showErrorDialog(
          context, 'Something went wrong. Please try again later.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final locationId = args['id'] as int;
    final name = args['name'] as String;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(name),
      ),
      body: FutureBuilder(
        future: _getLocationDetail(context, locationId),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () => _getLocationDetail(context, locationId),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Consumer<Locations>(
                      builder: (ctx, locationsData, _) => ChangeNotifierProvider.value(
                        value: locationsData.locationDetail.location,
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
                      child: Consumer<Locations>(
                        builder: (ctx, locationsData, _) => ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 5,
                          ),
                          itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
                            value: locationsData.locationDetail.sensors[index],
                            child: Padding(
                              padding: const EdgeInsets.only(
                                bottom: 10,
                              ),
                              child: DeviceCard(isLocationsScreen: true),
                            ),
                          ),
                          itemCount:
                              locationsData.locationDetail.sensors.length,
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
