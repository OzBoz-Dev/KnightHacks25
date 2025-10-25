import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.account_circle)
          )
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Text(
            "Fridges list here"
          ),
        )
      )
    );
  }
}