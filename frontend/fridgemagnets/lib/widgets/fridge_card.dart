import 'package:flutter/material.dart';
import 'package:fridgemagnets/models/fridge.dart';
import 'package:fridgemagnets/pages/fridge_page.dart';
import 'package:fridgemagnets/providers/auth_provider.dart';
import 'package:fridgemagnets/providers/fridge_provider.dart';
import 'package:fridgemagnets/services/fridge_service.dart';
import 'package:provider/provider.dart';

class FridgeCard extends StatelessWidget {
  final Fridge fridge;
  const FridgeCard({super.key, required this.fridge});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
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
              child: SizedBox( // Fridge thumbnail placeholder
                width: 100,
                height: 200,
                child: Image.asset('assets/fridge.png', fit: BoxFit.contain,),
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
            Text(
              "Danger Zone",
              style: TextStyle(
                color: Colors.red,
                fontSize: 18
              ),
            ),
            const SizedBox(height: 10,),
            ElevatedButton.icon(
              onPressed: () async {
                try {
                  final fridgeProvider = context.read<FridgeProvider>();
                  await fridgeProvider.deleteFridge(authProvider.token!, fridge);
                  if(context.mounted) {
                    if(fridgeProvider.errorMessage == null) {
                       ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Deleted fridge: $fridgeName"),
                          backgroundColor: Colors.green,
                        )
                      );
                    }
                    else {
                       ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Failed to close fridge: $fridgeName"),
                            backgroundColor: Colors.red,
                          )
                        );
                    }
                  }
                }
                catch(e) {
                  return;
                }
              },
              label: Text("Close Fridge", style: TextStyle(color: Colors.white),),
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.red)
              ),
            ),
            const SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }
}