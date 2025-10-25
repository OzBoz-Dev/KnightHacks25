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
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.blue[500]),
              ),
              onPressed: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (context) {
                    return SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          "Magnets list here",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.blue[500],
                          ),
                        ),
                      )
                    );
                  }
                );
              },
              label: Text(
                "Open Magnets",
                style: TextStyle(
                  color: Colors.white
                ),
              ),
              icon: Icon(Icons.arrow_drop_up, color: Colors.white,),
            ),
          ),
        ),
      ),
    );
  }
}