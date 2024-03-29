import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String message;

  const ErrorDialog(this.message, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('An Error Occurred'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Okay'),
        )
      ],
    );
  }
}

class DialogUtils {
  static void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => ErrorDialog(message),
    );
  }
}
