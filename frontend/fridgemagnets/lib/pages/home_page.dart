import 'package:flutter/material.dart';
import 'package:fridgemagnets/models/fridge.dart';
import 'package:fridgemagnets/pages/add_fridge_page.dart';
import 'package:fridgemagnets/pages/login_page.dart';
import 'package:fridgemagnets/providers/auth_provider.dart';
import 'package:fridgemagnets/providers/fridge_provider.dart';
import 'package:fridgemagnets/services/fridge_service.dart';
import 'package:fridgemagnets/widgets/fridge_card.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final _fridgeNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
            },
            icon: Icon(Icons.account_circle)
          )
        ],
      ),
      body: SafeArea(
        child: Consumer<AuthProvider>(
          builder: (context, auth, child) {
            if(auth.token == null && auth.username == null) {
              return Center(
                child: Text(
                  "You aren't logged in! Please log in to create or view fridges.",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold
                  ),
                )
              );
            }
            else {
              return Consumer<FridgeProvider>(
                builder: (context, fridgeProvider, child) {
                  // Fetch fridges once when the widget builds
                  if (fridgeProvider.fridges.isEmpty && !fridgeProvider.isLoading && fridgeProvider.errorMessage == null) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      fridgeProvider.fetchFridgesByUsername(auth.username!);
                    });
                  }
        
                  // Show loading indicator
                  if (fridgeProvider.isLoading) {
                    return Center(child: CircularProgressIndicator());
                  }
        
                  // Show error message
                  if (fridgeProvider.errorMessage != null) {
                    return Center(
                      child: Text(
                        fridgeProvider.errorMessage!,
                        style: TextStyle(color: Colors.red, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
        
                  // Show list of fridges
                  if (fridgeProvider.fridges.isEmpty) {
                    return Center(
                      child: Text(
                        "No fridges found.",
                        style: TextStyle(fontSize: 24),
                      ),
                    );
                  }
        
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              "Your Fridges",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: fridgeProvider.fridges.length,
                            itemBuilder: (context, index) {
                              final fridge = fridgeProvider.fridges[index];
                              return FridgeCard(
                                fridge: fridge,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          }
        )
      ),
      floatingActionButton: Consumer<AuthProvider>(
        builder: (context, auth, child) {
          if(auth.token == null && auth.username == null) {
            return SizedBox.shrink();
          }
          return FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddFridgePage()));
            },
            tooltip: "Add a new Fridge",
            child: Icon(Icons.add),
          );
        }
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}