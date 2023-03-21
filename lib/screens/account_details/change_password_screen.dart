import 'package:flutter/material.dart';
import 'package:iot_devices_manager_app/models/requests/auth.dart';
import 'package:provider/provider.dart';

import '../../models/exceptions/http_exception.dart';
import '../../providers/auth.dart';
import '../../widgets/common/error_dialog.dart';

class ChangePasswordScreen extends StatefulWidget {
  static const routeName = '/change-password';

  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _changePasswordRequest = ChangePasswordRequest();
  final _newPasswordController = TextEditingController();
  var _showOldPassword = false;
  var _showNewPassword = false;
  var _showConfirmPassword = false;
  var _isLoading = false;
  final _passwordRegExp = RegExp(r'^(?=.*?[a-z])(?=.*?[A-Z])(?=.*?[0-9])(?=.*?[!@#$&*~]).{8,}$');

  Future<void> _submit() async {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      bool res = await Provider.of<Auth>(context, listen: false).changePassword(_changePasswordRequest);
      if (res) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password successfully changed.'),
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
      DialogUtils.showErrorDialog(
          context, 'Something went wrong when changing your password. Please try again later.');
    }
    setState(() {
      _isLoading = false;
    });
  }

  String? _validatePassword(String? value) {
    if (value!.isEmpty) {
      return 'Please enter your password';
    }

    if (!_passwordRegExp.hasMatch(value)) {
      return 'Password must contain at least one lowercase letter, one uppercase letter, one digit, one special character, and be at least 8 characters long';
    }

    return null;
  }

  Widget _getBulletText(String text) {
    return Row(
      children: [
        const Text(
          "\u2022",
          style: TextStyle(fontSize: 20),
        ), //bullet text
        const SizedBox(
          width: 10,
        ), //space between bullet and text
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyText1,
          ), //text
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Change Password'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Please create a new, strong password.',
                ),
                const SizedBox(
                  height: 16,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        obscureText: !_showOldPassword,
                        decoration: InputDecoration(
                          errorMaxLines: 3,
                          labelText: 'Old Password',
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _showOldPassword = !_showOldPassword;
                              });
                            },
                            icon: const Icon(Icons.remove_red_eye),
                            color: _showOldPassword ? Colors.teal : Colors.grey,
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your old password';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _changePasswordRequest.oldPassword = value;
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        obscureText: !_showNewPassword,
                        controller: _newPasswordController,
                        decoration: InputDecoration(
                          errorMaxLines: 3,
                          labelText: 'New Password',
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _showNewPassword = !_showNewPassword;
                              });
                            },
                            icon: const Icon(Icons.remove_red_eye),
                            color: _showNewPassword ? Colors.teal : Colors.grey,
                          ),
                        ),
                        validator: _validatePassword,
                        onSaved: (value) {
                          _changePasswordRequest.newPassword = value;
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        obscureText: !_showConfirmPassword,
                        decoration: InputDecoration(
                          errorMaxLines: 3,
                          labelText: 'Confirm Password',
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _showConfirmPassword = !_showConfirmPassword;
                              });
                            },
                            icon: const Icon(Icons.remove_red_eye),
                            color:
                                _showConfirmPassword ? Colors.teal : Colors.grey,
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != _newPasswordController.text) {
                            return 'Passwords do not match!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _changePasswordRequest.confirmedPassword = value;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  'Your password must contain at least:',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                _getBulletText('one lowercase letter'),
                _getBulletText('one uppercase letter'),
                _getBulletText('one digit'),
                _getBulletText('one special character (!@#\$&*~)'),
                _getBulletText('and be at least 8 characters long'),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submit,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : Text(
                              'Submit'.toUpperCase(),
                            ),
                    ),
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
