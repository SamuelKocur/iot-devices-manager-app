import 'package:flutter/material.dart';
import 'package:iot_devices_manager_app/models/responses/iot/sensor.dart';
import 'package:iot_devices_manager_app/providers/iot.dart';
import 'package:iot_devices_manager_app/widgets/common/information_text.dart';
import 'package:provider/provider.dart';

import '../../../themes/light/drop_down_menu.dart';
import '../../../themes/light/text_theme.dart';
import '../../../widgets/common/no_iot_devices.dart';
import '../../../widgets/device_card.dart';
import 'data_comparison_result_screen.dart';

class DataComparisonScreen extends StatefulWidget {
  static const routeName = '/data-comparison';
  final comparisonLimit = 5;

  const DataComparisonScreen({Key? key}) : super(key: key);

  @override
  State<DataComparisonScreen> createState() => _DataComparisonScreenState();
}

class _DataComparisonScreenState extends State<DataComparisonScreen> with SingleTickerProviderStateMixin {
  String? _selectedSensorType;
  List<Sensor> _availableSensors = [];

  Widget _buildSensors() {
    if (_selectedSensorType == null) {
      return const Center(
        child: Text(
          'To see sensors you have to choose type',
        ),
      );
    }

    if (_availableSensors.isEmpty) {
      return const Center(child: NoAvailableIoTDevicesWidget());
    }

    return Consumer<IoTDevicesData>(
      builder: (ctx, devicesData, _) => ListView.builder(
        padding: const EdgeInsets.symmetric(
          horizontal: 0,
          vertical: 5,
        ),
        itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
          value: _availableSensors[index],
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: 10,
            ),
            child: DeviceCard(isComparisonScreen: true),
          ),
        ),
        itemCount: _availableSensors.length,
      ),
    );
  }

  List<DropdownMenuItem<String>> _typesDropDownMenu() {
    var types = Provider.of<IoTDevicesData>(context, listen: false).getSensorTypes();
    return types
        .map(
          (type) => _selectedSensorType == type
              ? DropdownMenuItem(
                  value: type,
                  child: Text(
                    type,
                    style: SelectedDropDownItemStyle.data,
                  ),
                )
              : DropdownMenuItem(
                  value: type,
                  child: Text(
                    type,
                    style: UnselectedDropDownItemStyle.data,
                  ),
                ),
        )
        .toList();
  }

  @override
  void initState() {
    super.initState();
    var selectedSensors = Provider.of<IoTDevicesData>(context, listen: false).selectedSensorsForComparison;
    if (selectedSensors.isNotEmpty) {
      _selectedSensorType = selectedSensors[0].type;
      _availableSensors = Provider.of<IoTDevicesData>(context, listen: false).getSensorsByType(selectedSensors[0].type);
    }
  }

  @override
  Widget build(BuildContext context) {
    var iotDevicesData = Provider.of<IoTDevicesData>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Data comparison',
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ElevatedButton(
          onPressed: () {
            var selectedSensors = iotDevicesData.selectedSensorsForComparison.where((sensor) => sensor.type == _selectedSensorType);
            if (selectedSensors.length <= 1) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('You can\'t compare one or zero sensors.'),
                  duration: Duration(seconds: 3),
                ),
              );
            } else if (selectedSensors.length > widget.comparisonLimit) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                content: Text('You can compare max ${widget.comparisonLimit} sensors at a time.'),
                duration: const Duration(seconds: 3),
              ),
            );
            }
            else {
              Navigator.of(context).pushNamed(
                DataComparisonResultScreen.routeName,
                arguments: {
                  'sensors': selectedSensors,
                }
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Text('Compare'.toUpperCase(),),
          ),
        ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InformationTextWidget(
                'Compare data from multiple sensors with the same type. Select type and then select sensors you would like to compare.'),
            Row(
              children: [
                const Text(
                  'Sensor type: ',
                  style: TextInDetailsScreen.data,
                ),
                const SizedBox(
                  width: 10,
                ),
                DropdownButton(
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedSensorType = newValue;
                        _availableSensors = iotDevicesData.getSensorsByType(newValue);
                      });
                    }
                  },
                  hint: const Text('Choose sensor type'),
                  items: _typesDropDownMenu(),
                  value: _selectedSensorType,
                ),
              ],
            ),
            const Text(
              'Sensors: ',
              style: TextInDetailsScreen.data,
            ),
            Flexible(child: _buildSensors()),
          ],
        ),
      ),
    );
  }
}
