import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'assets/pages/chooseProject.dart';
import 'assets/pages/login_page.dart';
import 'assets/pages/dashboard.dart';
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

// void main() => runApp(
//   DevicePreview(
//     builder: (context) => MyApp(), // Wrap your app
//   ),
// );

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const SplashScreen(),
    );
  }
}
