import 'package:flutter/material.dart';

class SettingScreen extends StatelessWidget {
  static const routeName = '/settings';

  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(),
    );
  }
}
