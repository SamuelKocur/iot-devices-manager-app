import 'package:flutter/material.dart';
import 'package:iot_devices_manager_app/providers/auth.dart';
import 'package:iot_devices_manager_app/providers/iot.dart';
import 'package:iot_devices_manager_app/screens/auth/forgot_password_screen.dart';
import 'package:iot_devices_manager_app/screens/auth/login_screen.dart';
import 'package:iot_devices_manager_app/screens/auth/register_screen.dart';
import 'package:iot_devices_manager_app/screens/change_password_screen.dart';
import 'package:iot_devices_manager_app/screens/device_detail_screen.dart';
import 'package:iot_devices_manager_app/screens/devices_screen.dart';
import 'package:iot_devices_manager_app/screens/favorites_screen.dart';
import 'package:iot_devices_manager_app/screens/locations_detail_screen.dart';
import 'package:iot_devices_manager_app/screens/locations_screen.dart';
import 'package:iot_devices_manager_app/screens/splash_screen.dart';
import 'package:iot_devices_manager_app/themes/light/elevated_button_theme.dart';
import 'package:iot_devices_manager_app/themes/light/input_decoretion_theme.dart';
import 'package:iot_devices_manager_app/themes/light/text_button_theme.dart';
import 'package:iot_devices_manager_app/themes/light/text_theme.dart';
import 'package:provider/provider.dart';

import './screens/auth/welcome_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>(
          create: (_) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Devices>(
            create: (ctx) => Devices({}),
            update: (ctx, auth, previousDevices) => previousDevices ?? Devices(
                {})..update(auth.requestHeader)
        )
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, child) => MaterialApp(
          title: 'Smart-IoT',
          theme: ThemeData(
            colorScheme: const ColorScheme.light().copyWith(
              primary: const Color.fromRGBO(42, 179, 129, 1),
              secondary: Colors.red,
            ),
            fontFamily: 'Inter',
            elevatedButtonTheme: CustomElevatedButtonTheme(),
            textButtonTheme: CustomTextButtonTheme(),
            textTheme: CustomTextTheme.themeData,
            inputDecorationTheme: CustomInputDecorationTheme.themeData,
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
          home: auth.isLoggedIn
              ? const FavoritesScreen()
              : FutureBuilder(
                  future: auth.isAuth,
                  builder: (ctx, authSnapshot) {
                    if (authSnapshot.hasData) {
                      if (authSnapshot.data == true) {
                        return const FavoritesScreen();
                      }
                      return FutureBuilder(
                        future: auth.tryAutoLogin(),
                        builder: (ctx, authResultSnapshot) =>
                            authResultSnapshot.connectionState ==
                                    ConnectionState.waiting
                                ? const SplashScreen()
                                : const WelcomeScreen(),
                      );
                    } else {
                      return const SplashScreen();
                    }
                  },
                ),
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
        ),
      ),
    );
  }
}
