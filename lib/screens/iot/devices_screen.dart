import 'package:flutter/material.dart';
import 'package:iot_devices_manager_app/widgets/common/no_iot_devices.dart';
import 'package:provider/provider.dart';

import '../../models/device_types.dart';
import '../../providers/iot.dart';
import '../../themes/light/elevated_button_theme.dart';
import '../../widgets/common/error_dialog.dart';
import '../../widgets/device_card.dart';

class DevicesScreen extends StatefulWidget {
  static const routeName = '/devices';

  const DevicesScreen({Key? key}) : super(key: key);

  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  var _selectedTag = 'all';

  Future<void> _refreshDevices(BuildContext context) async {
    var selectedTag = _selectedTag == 'all' ? null : _selectedTag;
    try {
      await Provider.of<IoTDevicesData>(context, listen: false).fetchAndSetIoTDevices(type: selectedTag);
    } catch (error) {
      DialogUtils.showErrorDialog(
          context, 'Something went wrong when fetching the devices. Please try again later.');
    }
  }

  Widget _getTagWidget(int index) {
    return Container(
      margin: const EdgeInsets.only(
        right: 5,
      ),
      child: ElevatedButton(
        style: _selectedTag == DeviceTypes.values[index].text
            ? SelectedTagTheme().style
            : UnselectedTagTheme().style,
        onPressed: () {
          setState(() {
            _selectedTag = DeviceTypes.values[index].text;
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            DeviceTypes.values[index].text.toUpperCase(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(
            left: 5,
            top: 5,
            bottom: 5,
          ),
          alignment: Alignment.topLeft,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (int index = 0; index < DeviceTypes.values.length; index++)
                  _getTagWidget(index)
              ],
            ),
          ),
        ),
        Expanded(
          child: FutureBuilder(
            future: _refreshDevices(context),
            builder: (ctx, snapshot) => snapshot.connectionState ==
                    ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshDevices(context),
                    child: Consumer<IoTDevicesData>(
                      builder: (ctx, devicesData, _) =>
                          devicesData.sensors.isEmpty
                              ? const NoAvailableIoTDevicesWidget()
                              : ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 5,
                                  ),
                                  itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
                                    value: _selectedTag == 'all'
                                        ? devicesData.sensors[index]
                                        : devicesData.filteredSensors[index],
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 10,
                                      ),
                                      child: DeviceCard(),
                                    ),
                                  ),
                                  itemCount: _selectedTag == 'all'
                                      ? devicesData.sensors.length
                                      : devicesData.filteredSensors.length,
                                ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
