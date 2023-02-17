import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatelessWidget {
  static const routeName = '/change-password';

  const ChangePasswordScreen({Key? key}) : super(key: key);

  Future<void> _submit() async {
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: Center(
      //   child: SingleChildScrollView(
      //     child: Container(
      //       constraints: const BoxConstraints(maxWidth: 500),
      //       width: double.infinity,
      //       padding: const EdgeInsets.all(15),
      //       child: Column(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           Text(
      //             'Welcome back'.toUpperCase(),
      //             style: Theme.of(context).textTheme.headline1,
      //           ),
      //           const SizedBox(
      //             height: 3,
      //           ),
      //           Text(
      //             ' Login to your account',
      //             style: Theme.of(context).textTheme.bodyText1,
      //           ),
      //           const SizedBox(
      //             height: 50,
      //           ),
      //           TextFormField(
      //             decoration: const InputDecoration(
      //               labelText: 'Email',
      //             ),
      //             validator: (value) {
      //               if (value!.isEmpty) {
      //                 return 'Please enter username';
      //               }
      //               return null;
      //             },
      //             onSaved: (value) {},
      //           ),
      //           const SizedBox(
      //             height: 16,
      //           ),
      //           TextFormField(
      //             obscureText: !_showPassword,
      //             controller: _passwordController,
      //             decoration: InputDecoration(
      //               errorMaxLines: 3,
      //               labelText: 'Password',
      //               suffixIcon: IconButton(
      //                 onPressed: () {
      //                   setState(() {
      //                     _showPassword = !_showPassword;
      //                   });
      //                 },
      //                 icon: const Icon(Icons.remove_red_eye),
      //                 color: _showPassword ? Colors.teal : Colors.grey,
      //               ),
      //             ),
      //             validator: (value) {
      //               if (value!.isEmpty) {
      //                 return 'Please enter password ';
      //               }
      //               return null;
      //             },
      //             onSaved: (value) {},
      //           ),
      //           Row(
      //             mainAxisAlignment: MainAxisAlignment.end,
      //             children: [
      //               TextButton(
      //                 onPressed: () {
      //                   Navigator.of(context)
      //                       .pushNamed(ForgotPasswordScreen.routeName);
      //                 },
      //                 child: const Text(
      //                   'Forgot Password?',
      //                   style: TextStyle(
      //                     color: Colors.black,
      //                     fontSize: 13,
      //                     fontWeight: FontWeight.w600,
      //                   ),
      //                 ),
      //               ),
      //             ],
      //           ),
      //           Column(
      //             crossAxisAlignment: CrossAxisAlignment.center,
      //             children: [
      //               SizedBox(
      //                 width: double.infinity,
      //                 child: ElevatedButton(
      //                   onPressed: _submit,
      //                   child: Padding(
      //                     padding: const EdgeInsets.symmetric(
      //                       horizontal: 16,
      //                     ),
      //                     child: Text(
      //                       'Login'.toUpperCase(),
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //               TextButton(
      //                 onPressed: () {
      //                   Navigator.of(context).pop();
      //                 },
      //                 child: Text(
      //                   'Sign Up'.toUpperCase(),
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
