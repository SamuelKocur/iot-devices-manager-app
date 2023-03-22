import 'package:flutter/material.dart';

class SubmitButton extends StatefulWidget {
  bool isLoading;
  VoidCallback submit;

  SubmitButton({
    Key? key,
    required this.isLoading,
    required this.submit,
  }) : super(key: key);

  @override
  State<SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<SubmitButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 500),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: widget.submit,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: widget.isLoading
              ? const CircularProgressIndicator()
              : Text(
            'Submit'.toUpperCase(),
          ),
        ),
      ),
    );
  }
}
