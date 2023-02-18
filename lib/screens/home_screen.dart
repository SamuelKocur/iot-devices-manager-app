import 'package:flutter/material.dart';
import 'package:iot_devices_manager_app/screens/devices_screen.dart';
import 'package:iot_devices_manager_app/screens/favorites_screen.dart';
import 'package:iot_devices_manager_app/screens/locations_screen.dart';


import '../widgets/app_drawer.dart';

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
    _tabController = TabController(initialIndex: 1, length: 3, vsync: this);
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
        body: TabBarView(
          controller: _tabController,
          children: _tabPages,
        ),
      ),
    );
  }
}
