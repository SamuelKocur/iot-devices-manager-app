import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 100,
          child: Column(
            children: const [
              CircularProgressIndicator(),
              SizedBox(height: 15,),
              Text('Loading'),
            ],
          ),
        ),
      ),
    );
  }
}
