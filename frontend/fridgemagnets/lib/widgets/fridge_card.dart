import 'package:flutter/material.dart';
import 'package:fridgemagnets/models/fridge.dart';
import 'package:fridgemagnets/models/magnet.dart';
import 'package:fridgemagnets/pages/fridge_page.dart';

class FridgeCard extends StatelessWidget {
  final Fridge fridge;
  const FridgeCard({super.key, required this.fridge});

  @override
  Widget build(BuildContext context) {

    String fridgeName = fridge.name;

    return Card(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FridgePage(fridge: fridge,))
          );
        },
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
      ),
    );
  }
}