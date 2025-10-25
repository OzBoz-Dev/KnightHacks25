import 'package:flutter/material.dart';
import 'package:fridgemagnets/pages/home_page.dart';
import 'package:fridgemagnets/themes/style.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: fridgeMagnetsTheme,
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
