import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: SizedBox(
                  width: 900,
                  child: Image.asset(
                    'assets/fridge.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: ElevatedButton.icon(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.blue[500]),
                ),
                onPressed: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    constraints: const BoxConstraints(
                        maxWidth: double.infinity,
                    ),
                    context: context,
                    builder: (context) {
                      return SafeArea(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8)
                            )
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                child: Text(
                                  "Magnets",
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.blue[500],
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 80,
                                    height: 80,
                                    child: Image.asset(
                                      'assets/green_magnet.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  const SizedBox(width: 20,),
                                  SizedBox(
                                    width: 80,
                                    height: 80,
                                    child: Image.asset(
                                      'assets/yellow_magnet.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  const SizedBox(width: 20,),
                                  SizedBox(
                                    width: 80,
                                    height: 80,
                                    child: Image.asset(
                                      'assets/red_magnet.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10,),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                child: Text(
                                  "Notes",
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.blue[500],
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 80,
                                    height: 80,
                                    child: Image.asset(
                                      'assets/sticky_note.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  const SizedBox(width: 20,),
                                  SizedBox(
                                    width: 80,
                                    height: 80,
                                    child: ColorFiltered(
                                      colorFilter: ColorFilter.mode(
                                        Colors.pink[200]!,
                                        BlendMode.srcIn
                                      ),
                                      child: Image.asset(
                                        'assets/sticky_note.png',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20,),
                                  SizedBox(
                                    width: 80,
                                    height: 80,
                                    child: ColorFiltered(
                                      colorFilter: ColorFilter.mode(
                                        Colors.blue[200]!,
                                        BlendMode.srcIn
                                      ),
                                      child: Image.asset(
                                        'assets/sticky_note.png',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      );
                    }
                  );
                },
                label: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    "Open Magnets",
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 18
                    ),
                  ),
                ),
                icon: Icon(Icons.arrow_drop_up, color: Colors.white,),
              ),
            ),
          ),
        ],
      ),
    );
  }
}