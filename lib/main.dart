import 'package:flutter/material.dart';
import 'package:iot_devices_manager_app/models/responses/filter_data.dart';
import 'package:iot_devices_manager_app/providers/user.dart';
import 'package:iot_devices_manager_app/providers/data_filtering.dart';
import 'package:iot_devices_manager_app/providers/iot.dart';
import 'package:iot_devices_manager_app/providers/location.dart';
import 'package:iot_devices_manager_app/screens/about_screen.dart';
import 'package:iot_devices_manager_app/screens/account_details/account_details_screen.dart';
import 'package:iot_devices_manager_app/screens/account_details/change_password_screen.dart';
import 'package:iot_devices_manager_app/screens/account_details/personal_information_screen.dart';
import 'package:iot_devices_manager_app/screens/auth/forgot_password_screen.dart';
import 'package:iot_devices_manager_app/screens/auth/login_screen.dart';
import 'package:iot_devices_manager_app/screens/auth/register_screen.dart';
import 'package:iot_devices_manager_app/screens/common/splash_screen.dart';
import 'package:iot_devices_manager_app/screens/iot/date_comparison/data_comparison_input_screen.dart';
import 'package:iot_devices_manager_app/screens/iot/date_comparison/data_comparison_result_screen.dart';
import 'package:iot_devices_manager_app/screens/iot/details/device_detail_screen.dart';
import 'package:iot_devices_manager_app/screens/iot/details/locations_detail_screen.dart';
import 'package:iot_devices_manager_app/screens/iot/home_screen.dart';
import 'package:iot_devices_manager_app/screens/settings_screen.dart';
import 'package:iot_devices_manager_app/themes/light/bar_theme.dart';
import 'package:iot_devices_manager_app/themes/light/card_theme.dart';
import 'package:iot_devices_manager_app/themes/light/check_box.dart';
import 'package:iot_devices_manager_app/themes/light/elevated_button_theme.dart';
import 'package:iot_devices_manager_app/themes/light/input_decoretion_theme.dart';
import 'package:iot_devices_manager_app/themes/light/text_button_theme.dart';
import 'package:iot_devices_manager_app/themes/light/text_theme.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import './screens/auth/welcome_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  List<SingleChildStatelessWidget> _getProviders(BuildContext context) {
    return [
      ChangeNotifierProvider<UserData>(
        create: (_) => UserData(),
      ),
      ChangeNotifierProvider<FilterResponse>(
        create: (_) => FilterResponse(
          dateFormat: 'd MMM y H:mm',
          data: [],
        ),
      ),
      ChangeNotifierProxyProvider<UserData, IoTDevicesData>(
          create: (ctx) => IoTDevicesData({}),
          update: (ctx, auth, previousDevices) =>
              previousDevices ?? IoTDevicesData({})
                ..update(auth.requestHeader),
      ),
      ChangeNotifierProxyProvider<UserData, LocationsData>(
          create: (ctx) =>
              LocationsData({}, Provider.of<IoTDevicesData>(ctx, listen: false)),
          update: (ctx, auth, previousLocations) => previousLocations ??
              LocationsData({}, Provider.of<IoTDevicesData>(ctx, listen: false))
            ..update(
              auth.requestHeader,
            ),
      ),
      ChangeNotifierProxyProvider<UserData, DataFiltering>(
          create: (ctx) => DataFiltering({}),
          update: (ctx, auth, _) => _ ?? DataFiltering({})
            ..update(auth.requestHeader),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: _getProviders(context),
      child: Consumer<UserData>(
        builder: (ctx, auth, child) => MaterialApp(
          title: 'Smart-IoT',
          theme: ThemeData(
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
            AboutScreen.routeName: (ctx) => const AboutScreen(),
            SettingScreen.routeName: (ctx) => const SettingScreen(),
            AccountDetailsScreen.routeName: (ctx) => const AccountDetailsScreen(),
            ChangePasswordScreen.routeName: (ctx) => const ChangePasswordScreen(),
            PersonalInformationScreen.routeName: (ctx) => const PersonalInformationScreen(),
            HomeScreen.routeName: (ctx) => const HomeScreen(),
            DeviceDetailScreen.routeName: (ctx) => const DeviceDetailScreen(),
            LocationDetailScreen.routeName: (ctx) => LocationDetailScreen(),
            DataComparisonScreen.routeName: (ctx) => const DataComparisonScreen(),
            DataComparisonResultScreen.routeName: (ctx) => const DataComparisonResultScreen(),
          },
        ),
      ),
    );
  }
}
