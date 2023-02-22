import 'package:flutter/material.dart';

enum DeviceTypes {
  all('all', null),
  temperature('temperature', Icons.thermostat_rounded),
  humidity('humidity', Icons.water_drop_outlined),
  motion('motion', Icons.directions_run),
  button('button', Icons.pause_circle_outline),
  led('led', Icons.lightbulb_outline_rounded),
  others('others', Icons.devices_other_outlined);

  const DeviceTypes(this.text, this.icon);
  final String text;
  final IconData? icon;
}
