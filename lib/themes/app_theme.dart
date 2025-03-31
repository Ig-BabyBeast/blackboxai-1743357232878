import 'package:flutter/material.dart';
import 'package:supply_mate/constants/app_constants.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: Color(0xFFFF5722),
    colorScheme: ColorScheme.light(
      primary: Color(0xFFFF5722),
      secondary: Color(0xFF607D8B),
    ),
    appBarTheme: AppBarTheme(
      color: Color(0xFFFF5722),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Color(0xFFFF5722),
    ),
  );

  static ThemeData darkTheme = ThemeData.dark().copyWith(
    colorScheme: ColorScheme.dark(
      primary: Color(0xFFE64A19),
      secondary: Color(0xFF455A64),
    ),
    appBarTheme: AppBarTheme(
      color: Color(0xFFE64A19),
    ),
  );
}