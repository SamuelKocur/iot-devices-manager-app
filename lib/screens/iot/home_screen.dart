import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:iot_devices_manager_app/providers/iot.dart';
import 'package:iot_devices_manager_app/providers/user.dart';

import 'package:iot_devices_manager_app/screens/iot/devices_screen.dart';
import 'package:iot_devices_manager_app/screens/iot/favorites_screen.dart';
import 'package:iot_devices_manager_app/screens/iot/locations_screen.dart';
import 'package:provider/provider.dart';


import '../../providers/location.dart';
import '../../widgets/app_drawer.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _tabPages = <Widget>[
    const DevicesScreen(),
    const FavoritesScreen(),
    const LocationsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    _tabController = TabController(initialIndex: 0, length: 3, vsync: this);
    Provider.of<UserData>(context, listen: false).fetchAppSettings();
    Provider.of<LocationsData>(context, listen: false).fetchAndSetLocations();
    Provider.of<IoTDevicesData>(context, listen: false).fetchAndSetIoTDevices();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Smart-IoT',
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(35),
            child: TabBar(
              controller: _tabController,
              tabs: [
                Text('Devices'.toUpperCase()),
                Text('Favorites'.toUpperCase()),
                Text('Locations'.toUpperCase()),
              ],
            ),
          ),
        ),
        drawer: const AppDrawer(),
        backgroundColor: Colors.white,
        body: TabBarView(
          controller: _tabController,
          children: _tabPages,
        ),
      ),
    );
  }
}
