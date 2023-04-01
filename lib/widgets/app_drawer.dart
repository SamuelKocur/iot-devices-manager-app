import 'package:flutter/material.dart';
import 'package:iot_devices_manager_app/screens/about_screen.dart';
import 'package:iot_devices_manager_app/screens/account_details/account_details_screen.dart';
import 'package:iot_devices_manager_app/screens/iot/home_screen.dart';
import 'package:iot_devices_manager_app/screens/settings_screen.dart';
import 'package:provider/provider.dart';

import './common/error_dialog.dart';
import '../providers/user.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  var _darkMode = false;

  void _logOut() {
    try {
      Provider.of<UserData>(context, listen: false).logout();
    } catch (error) {
      showDialog(
        context: context,
        builder: (ctx) =>
            const ErrorDialog('Could not log you out. Please try again later.'),
      );
    }
  }

  Widget _getListTile(
      {required IconData iconData,
      required String title,
      VoidCallback? onTap,
      Widget? trailing}) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Theme.of(context).colorScheme.background,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(7.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Icon(
            iconData,
          ),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.headline6,
        ),
        onTap: onTap,
        iconColor: Colors.black,
        trailing: trailing ??
            IconButton(
              icon: const Icon(Icons.keyboard_arrow_right_outlined),
              onPressed: onTap,
            ),
      ),
    );
  }

  double _calculateFreeHeight() {
    final screenHeight = MediaQuery.of(context).size.height;
    const appBarHeight = kToolbarHeight;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final fixedHeightWidgetsHeight = appBarHeight + statusBarHeight + 20 + 5 * 80;
    final freeHeight = screenHeight - fixedHeightWidgetsHeight;
    return freeHeight < 0 ? 0 : freeHeight;
  }

  @override
  Widget build(BuildContext context) {
    final firstName = Provider.of<UserData>(context).firstName;
    return Drawer(
      backgroundColor: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBar(
              title: Text(
                'Hey, $firstName!',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: Colors.black,
              automaticallyImplyLeading: false,
            ),
            _getListTile(
              iconData: Icons.home_outlined,
              title: 'Home',
              onTap: () {
                Navigator.of(context).pushNamed(HomeScreen.routeName);
              },
            ),
            _getListTile(
              iconData: Icons.account_circle_outlined,
              title: 'Account',
              onTap: () {
                Navigator.of(context).pushNamed(AccountDetailsScreen.routeName);
              },
            ),
            _getListTile(
              iconData: Icons.settings_outlined,
              title: 'Settings',
              onTap: () {
                Navigator.of(context).pushNamed(SettingScreen.routeName);
              },
            ),
            _getListTile(
              iconData: Icons.info_outline,
              title: 'About',
              onTap: () {
                Navigator.of(context).pushNamed(AboutScreen.routeName);
              },
            ),
            _getListTile(
              iconData: Icons.dark_mode_outlined,
              title: 'Dark mode',
              trailing: Switch(
                onChanged: (val) {
                  setState(() {
                    _darkMode = !_darkMode;
                  });
                },
                value: _darkMode,
                activeColor: Theme.of(context).colorScheme.primary,
              ),
            ),
            SizedBox(height: _calculateFreeHeight()),
            Align(
              alignment: Alignment.bottomCenter,
              child: _getListTile(
                iconData: Icons.logout_outlined,
                title: 'Log out',
                onTap: _logOut,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(
                'www.smart-iot.com',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
