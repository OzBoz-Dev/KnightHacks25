import 'package:flutter/material.dart';

class FridgeCard extends StatelessWidget {
  final String fridgeName;
  const FridgeCard({super.key, required this.fridgeName});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Container( // Fridge thumbnail placeholder
              width: 300,
              height: 200,
              color: Colors.grey,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                fridgeName,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}