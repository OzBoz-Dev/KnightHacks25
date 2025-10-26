import 'package:flutter/material.dart';
import 'package:fridgemagnets/pages/login_page.dart';
import 'package:fridgemagnets/providers/auth_provider.dart';
import 'package:fridgemagnets/providers/fridge_provider.dart';
import 'package:fridgemagnets/widgets/fridge_card.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
        child: SingleChildScrollView(
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

                    return ListView.builder(
                      itemCount: fridgeProvider.fridges.length,
                      itemBuilder: (context, index) {
                        final fridge = fridgeProvider.fridges[index];
                        return FridgeCard(
                          fridgeName: fridge.name,
                          // pass other fridge details if needed
                        );
                      },
                    );
                  },
                );
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 30,
                  itemBuilder: (context, index) {
                    return FridgeCard(
                      fridgeName: "Fridge ${index + 1}"
                    );
                  },
                )
              ],
            ),
          ),
        )
      )
    );
  }
}