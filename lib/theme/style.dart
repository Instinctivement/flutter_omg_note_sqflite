import 'package:flutter/material.dart';
import 'package:flutter_omg_note_sqflite/constants/constant.dart';

class Style {
  static ThemeData themeData(bool isDarkTheme) {
    return ThemeData(
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      appBarTheme: isDarkTheme
          ? const AppBarTheme(
              backgroundColor: darkGreyClr,
            )
          : const AppBarTheme(
              backgroundColor: primaryClr,
            ),
      scaffoldBackgroundColor:
          isDarkTheme ? const Color(0xFF222222) : Colors.white,
    );
  }
}
