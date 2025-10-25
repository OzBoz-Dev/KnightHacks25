import 'package:flutter/material.dart';

ThemeData fridgeMagnetsTheme = ThemeData(
  colorScheme: ColorScheme.light(
    primary: Colors.blue[500]!,
    onPrimary: Colors.white,
    secondary: Colors.blue[300]!,
    onSecondary: Colors.white,
    surface: const Color.fromARGB(255, 225, 225, 225),
    onSurface: Colors.black,
  ),
  appBarTheme: AppBarTheme(
    data: AppBarThemeData(
      backgroundColor: Colors.blue[500],
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold
      ),
      actionsIconTheme: IconThemeData(
        color: Colors.white,
        size: 28
      )
    ),
  ),

);