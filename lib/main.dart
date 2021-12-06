import 'package:flutter/material.dart';
import 'package:flutter_omg_note_sqflite/views/home_page.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
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
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: splash,
    );
  }
}
