import 'package:flutter/material.dart';
import 'package:iot_devices_manager_app/screens/auth/forgot_password_screen.dart';
import 'package:iot_devices_manager_app/screens/auth/login_screen.dart';
import 'package:iot_devices_manager_app/screens/auth/register_screen.dart';
import 'package:iot_devices_manager_app/screens/change_password_screen.dart';
import 'package:iot_devices_manager_app/screens/device_detail_screen.dart';
import 'package:iot_devices_manager_app/screens/devices_screen.dart';
import 'package:iot_devices_manager_app/screens/favorites_screen.dart';
import 'package:iot_devices_manager_app/screens/locations_detail_screen.dart';
import 'package:iot_devices_manager_app/screens/locations_screen.dart';

import './screens/auth/welcome_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart-IoT',
      theme: ThemeData(
        colorScheme: const ColorScheme.light().copyWith(
          primary: const Color.fromRGBO(42, 179, 129, 1),
          secondary: Colors.red,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            elevation: MaterialStateProperty.all<double>(0),
            backgroundColor: MaterialStateProperty.all<Color>(
              const Color.fromRGBO(42, 179, 129, 1),
            ),
            foregroundColor: MaterialStateProperty.all<Color>(
              Colors.black,
            ),
            alignment: Alignment.center,
            padding: MaterialStateProperty.all<EdgeInsets>(
              const EdgeInsets.symmetric(
                vertical: 12,
              ),
            ),
            textStyle: MaterialStateProperty.all<TextStyle>(
              const TextStyle(
                fontSize: 16,
                letterSpacing: 0.25,
                fontWeight: FontWeight.w600,
              ),
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            primary: Colors.black,
            textStyle: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              letterSpacing: 0.25,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        fontFamily: 'Inter',
        textTheme: ThemeData.light().textTheme.copyWith(
              headline1: const TextStyle(
                color: Colors.black,
                fontSize: 28,
                fontWeight: FontWeight.w600,
              ),
              bodyText1: const TextStyle(
                color: Color.fromRGBO(74, 72, 99, 1),
                fontSize: 14,
              ),
              bodyText2: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color.fromRGBO(245, 245, 245, 1),
          contentPadding: const EdgeInsets.all(8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        tabBarTheme: const TabBarTheme(
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(color: Colors.black),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          labelPadding: EdgeInsets.all(5),
        ),
      ),
      home: const WelcomeScreen(),
      routes: {
        WelcomeScreen.routeName: (ctx) => const WelcomeScreen(),
        LoginScreen.routeName: (ctx) => const LoginScreen(),
        RegisterScreen.routeName: (ctx) => const RegisterScreen(),
        ForgotPasswordScreen.routeName: (ctx) => const ForgotPasswordScreen(),
        ChangePasswordScreen.routeName: (ctx) => const ChangePasswordScreen(),
        DevicesScreen.routeName: (ctx) => const DevicesScreen(),
        DeviceDetailScreen.routeName: (ctx) => const DeviceDetailScreen(),
        FavoritesScreen.routeName: (ctx) => const FavoritesScreen(),
        LocationsScreen.routeName: (ctx) => const LocationsScreen(),
        LocationDetailScreen.routeName: (ctx) => const LocationDetailScreen(),
      },
    );
  }
}
