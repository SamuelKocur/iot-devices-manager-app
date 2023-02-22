import 'package:flutter/material.dart';
import 'package:iot_devices_manager_app/models/requests/auth.dart';
import 'package:provider/provider.dart';

import 'package:iot_devices_manager_app/screens/auth/forgot_password_screen.dart';
import 'package:iot_devices_manager_app/screens/auth/register_screen.dart';
import 'package:iot_devices_manager_app/widgets/auht_or_divider.dart';

import '../../models/exceptions/http_exception.dart';
import '../../providers/auth.dart';
import '../../widgets/common/error_dialog.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _loginRequest = LoginRequest();
  var _showPassword = false;
  var _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Auth>(context, listen: false).login(_loginRequest);
    } on HttpException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (error) {
      DialogUtils.showErrorDialog(context, 'Could not authenticate you. Please try again later.');
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            width: double.infinity,
            margin: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius:
                        const BorderRadius.all(Radius.circular(20)),
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        repeat: ImageRepeat.noRepeat,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      'Smart-IoT',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 3,
                ),
                // Padding(
                //   padding: const EdgeInsets.only(left: 20),
                //   child: Text(
                //     'Control all your smart devices, from anywhere and anytime.',
                //     style: Theme.of(context).textTheme.bodyText1,
                //     textAlign: TextAlign.center,
                //   ),
                // ),
                const SizedBox(
                  height: 40,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Email',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _loginRequest.email = value;
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        obscureText: !_showPassword,
                        decoration: InputDecoration(
                          errorMaxLines: 3,
                          labelText: 'Password',
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _showPassword = !_showPassword;
                              });
                            },
                            icon: const Icon(Icons.remove_red_eye),
                            color: _showPassword ? Colors.teal : Colors.grey,
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your password ';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _loginRequest.password = value;
                        },
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(ForgotPasswordScreen.routeName);
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (_isLoading)
                      const CircularProgressIndicator()
                    else
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submit,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            child: Text(
                              'Login'.toUpperCase(),
                            ),
                          ),
                        ),
                      ),
                    const OrWidget(),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(RegisterScreen.routeName);
                      },
                      child: Text(
                        'Sign Up'.toUpperCase(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
