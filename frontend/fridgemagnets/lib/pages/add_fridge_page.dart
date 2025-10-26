import 'package:flutter/material.dart';
import 'package:fridgemagnets/providers/auth_provider.dart';
import 'package:fridgemagnets/services/fridge_service.dart';
import 'package:provider/provider.dart';

class AddFridgePage extends StatefulWidget {
  const AddFridgePage({super.key});

  @override
  State<AddFridgePage> createState() => _AddFridgePageState();
}

class _AddFridgePageState extends State<AddFridgePage> {

  final _fridgeNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Fridge"),),
      body: Consumer<AuthProvider>(
        builder: (context, auth, child) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Enter Fridge Name",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: _fridgeNameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    hintText: "Fridge Name",
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close dialog
                      },
                      child: Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final fridgeName = _fridgeNameController.text.trim();
                        if (fridgeName.isNotEmpty) {
                          try {
                            await FridgeService().createFridge(
                              auth.token!,
                              fridgeName,
                              auth.username!
                            );
                          }
                          catch(e) {
                            print("Error: ${e.toString()}");
                          }
                        }
                      },
                      child: Text(
                        "Add",
                        style: TextStyle(
                          color: Colors.white
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}