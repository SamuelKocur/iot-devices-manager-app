import 'package:flutter/material.dart';
import 'package:iot_devices_manager_app/models/requests/auth.dart';
import 'package:iot_devices_manager_app/widgets/common/custom_input_field.dart';
import 'package:iot_devices_manager_app/widgets/common/submit_button.dart';
import 'package:provider/provider.dart';

import '../../models/exceptions/http_exception.dart';
import '../../providers/user.dart';
import '../../widgets/common/error_dialog.dart';

class PersonalInformationScreen extends StatefulWidget {
  static const routeName = '/personal-info';

  const PersonalInformationScreen({Key? key}) : super(key: key);

  @override
  State<PersonalInformationScreen> createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  bool _isLoading = false;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  String? _firstName;
  String? _lastName;

  Future<void> _submit() async {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    if (_firstName?.isEmpty ?? false) {
      _firstName = null;
    }
    if (_lastName?.isEmpty ?? false) {
      _lastName = null;
    }
    if (_firstName == null && _lastName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile information didn\'t change.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      UpdateProfileRequest request = UpdateProfileRequest(
        firstName: _firstName,
        lastName: _lastName,
      );
      bool res = await Provider.of<UserData>(context, listen: false).updateProfile(request);
      if (res) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile information successfully updated.'),
            duration: Duration(seconds: 2),
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
      DialogUtils.showErrorDialog(
          context, 'Something went wrong when changing your profile information. Please try again later.');
    }
    setState(() {
      _isLoading = false;
    });
  }

  Widget _getInfoWidget({
    required BuildContext context,
    required String leadingText,
    String hintText = "",
    TextEditingController? controller,
    Function(String)? onChanged,
    bool enabled = false,
  }) {
    return ListTile(
      leading: SizedBox(
        width: 80,
        child: Text(
          leadingText,
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      title: CustomInputFieldWidget(
        hintText: hintText,
        controller: controller,
        onChanged: onChanged,
        enabled: enabled,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    UserData auth = Provider.of<UserData>(context, listen: false);
    _firstNameController.text = auth.firstName ?? 'First name';
    _lastNameController.text = auth.lastName ?? 'Last name';
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Personal Information'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            width: double.infinity,
            child: Column(
              children: [
                _getInfoWidget(
                  context: context,
                  leadingText: 'Email',
                  hintText: auth.email ?? 'email',
                ),
                _getInfoWidget(
                    context: context,
                    leadingText: 'First Name',
                    hintText: auth.firstName ?? 'first name',
                    onChanged: (val) {
                      _firstName = val;
                    },
                    controller: _firstNameController,
                    enabled: true,
                ),
                _getInfoWidget(
                    context: context,
                    leadingText: 'Last Name',
                    hintText: auth.lastName ?? 'last name',
                    onChanged: (val) {
                      _lastName = val;
                    },
                    controller: _lastNameController,
                    enabled: true,
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  constraints: const BoxConstraints(maxWidth: 500),
                  padding: const EdgeInsets.all(15),
                  child: SubmitButton(
                    isLoading: _isLoading,
                    submit: _submit,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
