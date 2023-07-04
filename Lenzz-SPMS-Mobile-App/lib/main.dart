import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'assets/pages/onBoarding_screen.dart';
import 'assets/pages/splashScreen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future <void> main () async {
  await dotenv.load();
  runApp(
  DevicePreview(
    builder: (context) => MyApp(), // Wrap your app
  ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const onBoardingScreen(),
    );
  }
}
