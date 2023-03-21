import 'package:flutter/material.dart';
import 'package:iot_devices_manager_app/models/device_types.dart';
import 'package:iot_devices_manager_app/models/responses/iot.dart';
import 'package:iot_devices_manager_app/screens/iot/details/device_detail_screen.dart';
import 'package:iot_devices_manager_app/screens/iot/details/locations_detail_screen.dart';
import 'package:iot_devices_manager_app/themes/light/text_theme.dart';
import 'package:provider/provider.dart';

import '../providers/iot.dart';
import '../providers/location.dart';
import '../themes/light/elevated_button_theme.dart';

class DeviceCard extends StatelessWidget {
  var isLocationsScreen = false;

  DeviceCard({
    Key? key,
    this.isLocationsScreen = false,
  }) : super(key: key);

  Widget _getLatestValueWidget(Sensor sensor, BuildContext context) {
    if (sensor.isBoolSensor()) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Last activity:',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Text(
            sensor.getFormattedDate(),
            style: DeviceCardTextStyle.data,
          ),
        ],
      );
    }
    return Text(
      sensor.getFormattedLatestValue(),
      style: Theme.of(context).textTheme.headline1,
    );
  }

  @override
  Widget build(BuildContext context) {
    final sensor = Provider.of<Sensor>(context, listen: false);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          DeviceDetailScreen.routeName,
          arguments: {
            'id': sensor.id,
            'name': sensor.getCustomNameOrName(),
          },
        );
      },
      child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Consumer2<Sensor, Locations>(
                  builder: (ctx, sensor, locations, _) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        sensor.getCustomNameOrName(),
                        style: DeviceCardTextStyle.data,
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          enableFeedback: false,
                          onPressed: () => Provider.of<IoTDevices>(context, listen: false).toggleFavoriteSensors(sensor.id),
                          icon: Icon(
                            sensor.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: sensor.isFavorite ? Colors.pink : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(7.0),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            DeviceTypes.values
                                .firstWhere(
                                    (element) => element.text == sensor.type,
                                    orElse: () => DeviceTypes.others)
                                .icon,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        _getLatestValueWidget(sensor, context),
                      ],
                    ),
                    isLocationsScreen == true
                    ? const SizedBox()
                    : Consumer<Locations>(
                      builder: (ctx, location, _) => ElevatedButton(
                        style: WhiteButtonTheme().style,
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            LocationDetailScreen.routeName,
                            arguments: {
                              'id': sensor.device.location.id,
                              'name': sensor.device.location.getCustomNameOrName(),
                            },
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Text(
                            sensor.device.location.getCustomNameOrName(),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }
}
