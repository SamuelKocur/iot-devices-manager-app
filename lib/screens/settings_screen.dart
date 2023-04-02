import 'package:flutter/material.dart';
import 'package:iot_devices_manager_app/common/date_format.dart';
import 'package:iot_devices_manager_app/models/app_settings.dart';
import 'package:iot_devices_manager_app/widgets/common/information_text.dart';
import 'package:iot_devices_manager_app/widgets/common/submit_button.dart';
import 'package:provider/provider.dart';

import '../models/data_filtering.dart';
import '../models/exceptions/http_exception.dart';
import '../providers/user.dart';
import '../themes/light/drop_down_menu.dart';
import '../widgets/common/error_dialog.dart';

class SettingScreen extends StatefulWidget {
  static const routeName = '/settings';

  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  UserAppSettings _userAppSettings = UserAppSettings();
  var _isLoading = false;

  Future<void> _submit() async {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    setState(() {
      _isLoading = true;
    });
    bool res = false;
    try {
      res = await Provider.of<UserData>(context, listen: false).updateAppSettings(_userAppSettings);
      if (res) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Settings successfully changed.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } on HttpException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (error) {
      DialogUtils.showErrorDialog(context, 'Something went wrong when changing your settings. Please try again later.');
    }
    setState(() {
      _isLoading = false;
    });
  }


  List<DropdownMenuItem<String>> _dateFormatDropDownMenu() {
    return DateFormatter.availableDateTimeFormats
        .map(
          (format) => _userAppSettings.dateFormat == format
              ? DropdownMenuItem(
                  value: format,
                  child: Text(
                    DateFormatter.byFormat(DateTime.now(), format),
                    style: SelectedDropDownItemStyle.data,
                  ),
                )
              : DropdownMenuItem(
                  value: format,
                  child: Text(
                    DateFormatter.byFormat(DateTime.now(), format),
                    style: UnselectedDropDownItemStyle.data,
                  ),
                ),
        )
        .toList();
  }

  List<DropdownMenuItem<String>> _dateRangeDropDownMenu() {
    return DateRangeOptions.values
        .map(
          (e) => _userAppSettings.dateRangeOption.text == e.text
              ? DropdownMenuItem(
                  value: e.text,
                  child: Text(
                    e.text,
                    style: SelectedDropDownItemStyle.data,
                  ),
                )
              : DropdownMenuItem(
                  value: e.text,
                  child: Text(
                    e.text,
                    style: UnselectedDropDownItemStyle.data,
                  ),
                ),
        )
        .toList();
  }

  Widget _buildSettingValue({required String trailingText, required Widget widget}) {
    return Row(
      children: [
        Text(
          trailingText,
        ),
        const SizedBox(
          width: 10,
        ),
        widget,
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _userAppSettings = Provider.of<UserData>(context, listen: false).userAppSettings;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InformationTextWidget(
                  'Set default app behaviour'
              ),
              const SizedBox(
                height: 8,
              ),
              // _buildSettingValue(
              //     trailingText: 'Date Format:',
              //     widget : DropdownButton(
              //       onChanged: (String? newValue) {
              //         if (newValue != null) {
              //           setState(() {
              //             _userAppSettings.dateFormat = newValue;
              //           });
              //         }
              //       },
              //       items: _dateFormatDropDownMenu(),
              //       value: _userAppSettings.dateFormat,
              //     ),
              // ),
              _buildSettingValue(
                trailingText: 'Get data for:',
                widget: DropdownButton(
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _userAppSettings.getDataFor = newValue;
                      });
                    }
                  },
                  items: _dateRangeDropDownMenu(),
                  value: _userAppSettings.getDataFor,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Graph settings:',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              _buildSettingValue(
                trailingText: 'Animate:',
                widget: Switch(
                  onChanged: (val) {
                    setState(() {
                      _userAppSettings.graphAnimate = !_userAppSettings.graphAnimate;
                    });
                  },
                  value: _userAppSettings.graphAnimate,
                  activeColor: Theme.of(context).colorScheme.primary,
                ),
              ),
              _buildSettingValue(
                trailingText: 'Include Points:',
                widget: Switch(
                  onChanged: (val) {
                    setState(() {
                      _userAppSettings.graphIncludePoints = !_userAppSettings.graphIncludePoints;
                    });
                  },
                  value: _userAppSettings.graphIncludePoints,
                  activeColor: Theme.of(context).colorScheme.primary,
                ),
              ),
              _buildSettingValue(
                trailingText: 'Show Minimum values:',
                widget: Switch(
                  onChanged: (val) {
                    setState(() {
                      _userAppSettings.graphShowMin = !_userAppSettings.graphShowMin;
                    });
                  },
                  value: _userAppSettings.graphShowMin,
                  activeColor: Theme.of(context).colorScheme.primary,
                ),
              ),
              _buildSettingValue(
                trailingText: 'Show Average values:',
                widget: Switch(
                  onChanged: (val) {
                    setState(() {
                      _userAppSettings.graphShowAvg = !_userAppSettings.graphShowAvg;
                    });
                  },
                  value: _userAppSettings.graphShowAvg,
                  activeColor: Theme.of(context).colorScheme.primary,
                ),
              ),
              _buildSettingValue(
                trailingText: 'Show Maximum values:',
                widget: Switch(
                  onChanged: (val) {
                    setState(() {
                      _userAppSettings.graphShowMax = !_userAppSettings.graphShowMax;
                    });
                  },
                  value: _userAppSettings.graphShowMax,
                  activeColor: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SubmitButton(
                  isLoading: _isLoading,
                  submit: _submit,
              )
            ],
          ),
        ),
      ),
    );
  }
}
