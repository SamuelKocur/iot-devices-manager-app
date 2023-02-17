import 'package:flutter/material.dart';

class OrWidget extends StatelessWidget {
  const OrWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Expanded(
            child: Divider(
              thickness: 1,
              color: Color.fromRGBO(234, 234, 234, 1),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            'Or'.toUpperCase(),
            style: const TextStyle(
              color: Color.fromRGBO(37, 33, 94, 1),
              fontSize: 14,
              letterSpacing: 0.25,
              fontWeight: FontWeight.normal,
              height: 1,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          const Expanded(
            child: Divider(
              thickness: 1,
              color: Color.fromRGBO(234, 234, 234, 1),
            ),
          ),
        ],
      ),
    );
  }
}
