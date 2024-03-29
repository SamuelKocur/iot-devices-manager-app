import 'package:flutter/material.dart';
import 'package:iot_devices_manager_app/screens/iot/details/locations_detail_screen.dart';
import 'package:iot_devices_manager_app/widgets/common/stroke_text.dart';
import 'package:provider/provider.dart';

import '../models/responses/iot/location.dart';

class LocationCard extends StatelessWidget {
  var isLocationsScreen = false;

  LocationCard({
    Key? key,
    this.isLocationsScreen = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final location = Provider.of<Location>(context, listen: false);
    return GestureDetector(
      onTap: () {
        if (isLocationsScreen) {
          return;
        }
        Navigator.of(context).pushNamed(
          LocationDetailScreen.routeName,
          arguments: {
            'id': location.id,
            'name': location.getCustomNameOrName(),
          },
        );
      },
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            Container(
              constraints: const BoxConstraints(maxWidth: 500),
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.20,
              child: Hero(
                tag: location.id,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: location.image != null
                      ? Image.network(
                          location.image!,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'assets/images/default-location.jpg',
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                          repeat: ImageRepeat.noRepeat,
                        ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BorderedText(
                      strokeColor: Colors.white,
                      strokeWidth: 3,
                      child: Text(
                        location.getCustomNameOrName(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 25,
                        ),
                      ),
                    ),
                    BorderedText(
                      strokeColor: Colors.white,
                      strokeWidth: 3,
                      child: Text(
                        location.getNumberOfDevices(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
