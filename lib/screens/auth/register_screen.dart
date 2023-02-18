import 'package:flutter/material.dart';
import 'package:iot_devices_manager_app/models/requests/auth.dart';
import 'package:iot_devices_manager_app/screens/auth/login_screen.dart';
import 'package:iot_devices_manager_app/widgets/auht_or_divider.dart';
import 'package:provider/provider.dart';

import '../../models/exceptions/http_exception.dart';
import '../../providers/auth.dart';
import '../../widgets/common/error_dialog.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/sign-up';

  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _registerRequest = RegisterRequest();
  final _passwordController = TextEditingController();
  var _showPassword = false;
  var _showConfirmPassword = false;
  var _isLoading = false;
  final _passwordRegExp =
      RegExp(r'^(?=.*?[a-z])(?=.*?[A-Z])(?=.*?[0-9])(?=.*?[!@#$&*~]).{8,}$');

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Auth>(context, listen: false).register(_registerRequest);
    } on HttpException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (error) {
      showDialog(
        context: context,
        builder: (ctx) => const ErrorDialog(
            'Could not create a new account for you. Please try again later.'
        ),
      );
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

  Widget _buildSignUpForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'First Name',
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your first name';
              }
              return null;
            },
            onSaved: (value) {
              _registerRequest.firstName = value;
            },
          ),
          const SizedBox(
            height: 16,
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Last Name',
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your last name';
              }
              return null;
            },
            onSaved: (value) {
              _registerRequest.lastName = value;
            },
          ),
          const SizedBox(
            height: 16,
          ),
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
              _registerRequest.email = value;
            },
          ),
          const SizedBox(
            height: 16,
          ),
          TextFormField(
            obscureText: !_showPassword,
            controller: _passwordController,
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
            validator: _validatePassword,
            onSaved: (value) {
              _registerRequest.password1 = value;
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
                color: _showConfirmPassword ? Colors.teal : Colors.grey,
              ),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please confirm your password';
              }
              if (value != _passwordController.text) {
                return 'Passwords do not match!';
              }
              return null;
            },
            onSaved: (value) {
              _registerRequest.password2 = value;
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sign up'.toUpperCase(),
                  style: Theme.of(context).textTheme.headline1,
                ),
                const SizedBox(
                  height: 3,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 3),
                  child: Text(
                    'Looks like you don’t have an account. Let’s create a new account for you.',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                _buildSignUpForm(),
                const SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 3),
                  child: Text.rich(
                    TextSpan(
                      text: 'By selecting ',
                      style: Theme.of(context).textTheme.bodyText1,
                      children: const [
                        TextSpan(
                          text: 'Create Account ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: 'below, I agree to Terms of Service & Privacy Policy',
                        )
                      ],
                    ),
                  )
                ),
                const SizedBox(
                  height: 16,
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
                              'Create account'.toUpperCase(),
                            ),
                          ),
                        ),
                      ),
                    const OrWidget(),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(LoginScreen.routeName);
                      },
                      child: Text(
                        'Login'.toUpperCase(),
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
