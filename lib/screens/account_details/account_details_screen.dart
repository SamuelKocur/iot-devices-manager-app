import 'package:flutter/material.dart';
import 'package:iot_devices_manager_app/screens/account_details/personal_information_screen.dart';
import 'package:iot_devices_manager_app/screens/account_details/change_password_screen.dart';
import 'package:provider/provider.dart';

import '../../providers/auth.dart';
import '../../widgets/common/error_dialog.dart';

class AccountDetailsScreen extends StatefulWidget {
  static const routeName = '/profile_detail';

  const AccountDetailsScreen({Key? key}) : super(key: key);

  @override
  State<AccountDetailsScreen> createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen> {

  Future<void> _logoutAll() async {
    try {
      await Provider.of<Auth>(context, listen: false).logoutAll();
    } catch (error) {
      DialogUtils.showErrorDialog(context, 'Something went wrong. Please try again later.');
    }
  }

  void _showLogoutConfirmDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Do you really want to logout from all devices?'),
        content: const Text(
            "You won't be able to login to your account from any device."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _logoutAll();
              // Navigator.of(ctx).pop();
              Navigator.of(ctx, rootNavigator: true).pop();
            },
            child: const Text('Log Out'),
          )
        ],
      ),
    );
  }

  Future<void> _deleteAccount() async {
    try {
      bool res = await Provider.of<Auth>(context, listen: true).deleteAccount();
      if (res == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account deleted successfully.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (error) {
      DialogUtils.showErrorDialog(context, 'Something went wrong. Please try again later.');
    }
  }

  void _showDeleteAccountConfirmDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Do you really want to delete your account?'),
        content: const Text(
            "Your account will be deactivated, and you will be logged out from all devices. Unless you contact the administrator, you will not be able to log in again."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _deleteAccount();
              Navigator.of(context, rootNavigator: true).pop();
            },
            child: const Text('Delete Account'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Account'),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text(
              'Personal Information',
              style: Theme.of(context).textTheme.headline6,
            ),
            onTap: () {
              Navigator.of(context).pushNamed(PersonalInformationScreen.routeName);
            },
            trailing: const IconButton(
              icon: Icon(Icons.keyboard_arrow_right_outlined),
              onPressed: null,
            ),
          ),
          ListTile(
            title: Text(
              'Change Password',
              style: Theme.of(context).textTheme.headline6,
            ),
            onTap: () {
              Navigator.of(context).pushNamed(ChangePasswordScreen.routeName);
            },
            trailing: const IconButton(
              icon: Icon(Icons.keyboard_arrow_right_outlined),
              onPressed: null,
            ),
          ),
          ListTile(
            title: Text(
              'Logout from all Devices',
              style: Theme.of(context).textTheme.headline6,
            ),
            onTap: () {
              _showLogoutConfirmDialog();
            },
            trailing: const IconButton(
              icon: Icon(Icons.keyboard_arrow_right_outlined),
              onPressed: null,
            ),
          ),
          ListTile(
            title: Text(
              'Delete Account',
              style: Theme.of(context).textTheme.headline6,
            ),
            onTap: () {
              _showDeleteAccountConfirmDialog();
            },
            trailing: const IconButton(
              icon: Icon(Icons.keyboard_arrow_right_outlined),
              onPressed: null,
            ),
          )
        ],
      ),
    );
  }
}