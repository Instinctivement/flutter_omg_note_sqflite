import 'package:flutter/material.dart';
import 'package:flutter_omg_note_sqflite/views/home_page.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'notification/notificationservice.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService.initNotification();
  await GetStorage.init;

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    Widget splash = SplashScreenView(
      navigateRoute: const HomePage(),
      duration: 3000,
      imageSize: 200,
      imageSrc: 'assets/logo.png',
      text: "Omg Note",
      textType: TextType.ColorizeAnimationText,
      textStyle: const TextStyle(
        fontSize: 40.0,
        fontWeight: FontWeight.bold,
      ),
      colors: const [
        Colors.purple,
        Colors.blue,
        Colors.yellow,
        Colors.red,
      ],
      backgroundColor: Colors.white,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OmgNote',
      home: splash,
    );
  }
}
