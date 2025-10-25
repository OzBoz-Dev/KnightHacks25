import 'package:flutter/material.dart';

class FridgePage extends StatefulWidget {
  final String fridgeName;
  const FridgePage({super.key, required this.fridgeName});

  @override
  State<FridgePage> createState() => _FridgePageState();
}

class _FridgePageState extends State<FridgePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.fridgeName),),
      body: const Placeholder(),
    );
  }
}