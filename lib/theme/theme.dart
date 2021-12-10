import 'package:flutter/material.dart';
import 'package:flutter_omg_note_sqflite/constants/constant.dart';

class Themes {
  static final lightMode = ThemeData(
    appBarTheme: const AppBarTheme(
      backgroundColor: white,
    ),
    brightness: Brightness.light,
  );

  static final darktMode = ThemeData(
    appBarTheme: const AppBarTheme(
      backgroundColor: darkGreyClr,
    ),
    brightness: Brightness.dark,
  );
}
