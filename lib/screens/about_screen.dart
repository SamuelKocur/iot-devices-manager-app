import 'package:flutter/material.dart';
import "package:simple_icons/simple_icons.dart";
import 'package:url_launcher/url_launcher.dart';


class AboutScreen extends StatelessWidget {
  static const routeName = '/about';

  const AboutScreen({Key? key}) : super(key: key);

  Widget getLinkWidget({
    required String link,
    required String text,
  }) {
    return GestureDetector(
      onTap: () {
        _launchUrl(link);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            const Icon(
              SimpleIcons.github,
              color: Colors.black,
            ),
            const SizedBox(
              width: 15,
            ),
            Text(
              text,
              style: const TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              const Text(
                "This application is part of bachelor's thesis, with the goal of creating a comprehensive system for managing IoT devices and analyzing the data they measure. The project comprises three main components: a server, a mobile app, and a web app."
              ),
              const SizedBox(
                height: 7,
              ),
              const Text(
                "To build the system, Django and Django Admin was used for the backend and web administration components, while the mobile app was developed using Flutter. The app is designed to track available IoT devices and perform data analysis."
              ),
              const SizedBox(
                height: 7,
              ),
              const Text(
                "If you're interested in exploring the system further, you can find the source code and some IoT device configuration details at:"
              ),
              const SizedBox(
                height: 7,
              ),
              getLinkWidget(
                link: 'https://github.com/SamuelKocur/iot-devices-manager-api',
                text: 'Server side & web administration',
              ),
              getLinkWidget(
                link: 'https://github.com/SamuelKocur/iot-devices-manager-app',
                text: 'Mobile app',
              ),
              getLinkWidget(
                link: 'https://github.com/SamuelKocur/iot-devices-manager-api/tree/main/arduino',
                text: 'IoT devices configurations',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
