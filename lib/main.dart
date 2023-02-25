import 'package:flutter/material.dart';
import 'package:iot_devices_manager_app/providers/auth.dart';
import 'package:iot_devices_manager_app/providers/iot.dart';
import 'package:iot_devices_manager_app/providers/location.dart';
import 'package:iot_devices_manager_app/screens/auth/forgot_password_screen.dart';
import 'package:iot_devices_manager_app/screens/auth/login_screen.dart';
import 'package:iot_devices_manager_app/screens/auth/register_screen.dart';
import 'package:iot_devices_manager_app/screens/change_password_screen.dart';
import 'package:iot_devices_manager_app/screens/details/device_detail_screen.dart';
import 'package:iot_devices_manager_app/screens/home_screen.dart';
import 'package:iot_devices_manager_app/screens/details/locations_detail_screen.dart';
import 'package:iot_devices_manager_app/screens/splash_screen.dart';
import 'package:iot_devices_manager_app/themes/light/bar_theme.dart';
import 'package:iot_devices_manager_app/themes/light/card_theme.dart';
import 'package:iot_devices_manager_app/themes/light/check_box.dart';
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
        ChangeNotifierProxyProvider<Auth, IoTDevices>(
            create: (ctx) => IoTDevices({}),
            update: (ctx, auth, previousDevices) => previousDevices ?? IoTDevices(
                {})..update(auth.requestHeader)
        ),
        ChangeNotifierProxyProvider<Auth, Locations>(
            create: (ctx) => Locations({}, Provider.of<IoTDevices>(ctx, listen: false)),
            update: (ctx, auth, previousLocations) => previousLocations ?? Locations(
                {}, Provider.of<IoTDevices>(ctx, listen: false))..update(auth.requestHeader, )
        )
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, child) => MaterialApp(
          title: 'Smart-IoT',
          theme: ThemeData(
            // remove the animation for all IconButton widgets in the app
            // splashColor: Colors.transparent,
            // highlightColor: Colors.transparent,
            colorScheme: const ColorScheme.light().copyWith(
              primary: const Color.fromRGBO(42, 179, 129, 1),
              background: const Color.fromRGBO(247, 247, 247, 1),
            ),
            cardTheme: CustomCardThemeTheme.themeData,
            fontFamily: 'Inter',
            elevatedButtonTheme: CustomElevatedButtonTheme(),
            textButtonTheme: CustomTextButtonTheme(),
            textTheme: CustomTextTheme.themeData,
            inputDecorationTheme: CustomInputDecorationTheme.themeData,
            appBarTheme: CustomAppBarTheme.themeData,
            tabBarTheme: CustomTabBarTheme.themeData,
            checkboxTheme: CustomCheckBoxTheme.themeData,
          ),
          home: auth.isLoggedIn
              ? const HomeScreen()
              : FutureBuilder(
                  future: auth.isAuth,
                  builder: (ctx, authSnapshot) {
                    if (authSnapshot.hasData) {
                      if (authSnapshot.data == true) {
                        return const HomeScreen();
                      }
                      return FutureBuilder(
                        future: auth.tryAutoLogin(),
                        builder: (ctx, authResultSnapshot) =>
                            authResultSnapshot.connectionState ==
                                    ConnectionState.waiting
                                ? const SplashScreen()
                                : const LoginScreen(),
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
            HomeScreen.routeName: (ctx) => const HomeScreen(),
            DeviceDetailScreen.routeName: (ctx) => const DeviceDetailScreen(),
            LocationDetailScreen.routeName: (ctx) => const LocationDetailScreen(),
          },
        ),
      ),
    );
  }
}
