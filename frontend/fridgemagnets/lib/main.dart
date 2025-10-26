import 'package:flutter/material.dart';
import 'package:fridgemagnets/pages/home_page.dart';
import 'package:fridgemagnets/providers/auth_provider.dart';
import 'package:fridgemagnets/providers/fridge_provider.dart';
import 'package:fridgemagnets/services/shared_prefs_service.dart';
import 'package:fridgemagnets/themes/style.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  // Init shared prefs
  await SharedPrefsService.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => FridgeProvider()),
      ],
      child: const MainApp()
    ),
  );
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
