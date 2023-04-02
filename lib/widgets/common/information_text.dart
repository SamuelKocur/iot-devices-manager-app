import 'package:flutter/material.dart';

class InformationTextWidget extends StatelessWidget {
  String text;

  InformationTextWidget(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          const WidgetSpan(
            child: Icon(
              Icons.info_outline_rounded,
              size: 20,
            ),
          ),
          TextSpan(text: '  $text'),
        ],
      ),
    );
  }
}
