import 'package:flutter/material.dart';
import 'package:fridgemagnets/models/fridge.dart';
import 'package:fridgemagnets/models/magnet.dart';
import 'package:fridgemagnets/providers/auth_provider.dart';
import 'package:fridgemagnets/services/magnet_service.dart';
import 'package:provider/provider.dart';

class FridgePage extends StatefulWidget {
  final Fridge fridge;
  const FridgePage({super.key, required this.fridge});

  @override
  State<FridgePage> createState() => _FridgePageState();
}

class _FridgePageState extends State<FridgePage> {

  // Local mutable copy of magnets
  late List<Magnet> _magnets;

  // For visual feedback on trash hover
  bool isTrashActive = false;

  @override
  void initState() {
    super.initState();
    _magnets = List.from(widget.fridge.magnets); // copy once
    for(int i = 0; i < _magnets.length; i++) {
      print("Magnet id: ${_magnets[i].id}");
    } 
  }

  @override
  Widget build(BuildContext context) {

    // Auth data
    final authProvider = context.read<AuthProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(widget.fridge.name)),

      // Stack lets us place the trash bin floating on top, bottom-right
      body: Stack(
        children: [
          // Main layout
          Row(
            children: [
              // Left panel with draggable magnets
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text("Magnets"),
                    Draggable<int>(
                      data: -1, // A special ID meaning "new magnet"
                      feedback: SizedBox(
                        width: 80,
                        height: 80,
                        child: Image.asset('assets/green_magnet.png'),
                      ),
                      childWhenDragging: Opacity(
                        opacity: 0.3,
                        child: SizedBox(
                          width: 80,
                          height: 80,
                          child: Image.asset('assets/green_magnet.png'),
                        ),
                      ),
                      child: SizedBox(
                        width: 80,
                        height: 80,
                        child: Image.asset('assets/green_magnet.png'),
                      ),
                    ),
                    Draggable<int>(
                      data: -2, // A special ID meaning "new magnet"
                      feedback: SizedBox(
                        width: 80,
                        height: 80,
                        child: Image.asset('assets/yellow_magnet.png'),
                      ),
                      childWhenDragging: Opacity(
                        opacity: 0.3,
                        child: SizedBox(
                          width: 80,
                          height: 80,
                          child: Image.asset('assets/yellow_magnet.png'),
                        ),
                      ),
                      child: SizedBox(
                        width: 80,
                        height: 80,
                        child: Image.asset('assets/yellow_magnet.png'),
                      ),
                    ),
                    Draggable<int>(
                      data: -3, // A special ID meaning "new magnet"
                      feedback: SizedBox(
                        width: 80,
                        height: 80,
                        child: Image.asset('assets/red_magnet.png'),
                      ),
                      childWhenDragging: Opacity(
                        opacity: 0.3,
                        child: SizedBox(
                          width: 80,
                          height: 80,
                          child: Image.asset('assets/red_magnet.png'),
                        ),
                      ),
                      child: SizedBox(
                        width: 80,
                        height: 80,
                        child: Image.asset('assets/red_magnet.png'),
                      ),
                    ),
                    const SizedBox(height: 20,),
                    const Text("Notes"),
                    Draggable<int>(
                      data: -4, // A special ID meaning "new magnet"
                      feedback: SizedBox(
                        width: 80,
                        height: 80,
                        child: Image.asset('assets/sticky_note.png'),
                      ),
                      childWhenDragging: Opacity(
                        opacity: 0.3,
                        child: SizedBox(
                          width: 80,
                          height: 80,
                          child: Image.asset('assets/sticky_note.png'),
                        ),
                      ),
                      child: SizedBox(
                        width: 80,
                        height: 80,
                        child: Image.asset('assets/sticky_note.png'),
                      ),
                    ),
                    Draggable<int>(
                      data: -5, // A special ID meaning "new magnet"
                      feedback: SizedBox(
                        width: 80,
                        height: 80,
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(Colors.pinkAccent, BlendMode.srcIn),
                          child: Image.asset('assets/sticky_note.png')
                        ),
                      ),
                      childWhenDragging: Opacity(
                        opacity: 0.3,
                        child: SizedBox(
                          width: 80,
                          height: 80,
                          child: ColorFiltered(
                            colorFilter: ColorFilter.mode(Colors.pinkAccent, BlendMode.srcIn),
                            child: Image.asset('assets/sticky_note.png')
                          ),
                        ),
                      ),
                      child: SizedBox(
                        width: 80,
                        height: 80,
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(Colors.pinkAccent, BlendMode.srcIn),
                          child: Image.asset('assets/sticky_note.png')
                        ),
                      ),
                    ),
                    Draggable<int>(
                      data: -6, // A special ID meaning "new magnet"
                      feedback: SizedBox(
                        width: 80,
                        height: 80,
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(Colors.lightBlue, BlendMode.srcIn),
                          child: Image.asset('assets/sticky_note.png')
                        ),
                      ),
                      childWhenDragging: Opacity(
                        opacity: 0.3,
                        child: SizedBox(
                          width: 80,
                          height: 80,
                          child: ColorFiltered(
                            colorFilter: ColorFilter.mode(Colors.lightBlue, BlendMode.srcIn),
                            child: Image.asset('assets/sticky_note.png')
                          ),
                        ),
                      ),
                      child: SizedBox(
                        width: 80,
                        height: 80,
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(Colors.lightBlue, BlendMode.srcIn),
                          child: Image.asset('assets/sticky_note.png')
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Fridge area
              Expanded(
                child: SingleChildScrollView(
                  child: Center(
                    child: SizedBox(
                      width: 600,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return DragTarget<int>(
                            onAcceptWithDetails: (details) async {
                              final RenderBox box = context.findRenderObject() as RenderBox;
                              final Offset localOffset = box.globalToLocal(details.offset);

                              // New magnet (from sidebar)
                              if (details.data <= -1) {
                                String imageUrl = "";
                                Color color = Colors.transparent;
                                switch(details.data) {
                                  case -1:
                                    imageUrl = 'assets/green_magnet.png';
                                    break;
                                  case -2:
                                    imageUrl = 'assets/yellow_magnet.png';
                                    break;
                                  case -3:
                                    imageUrl = 'assets/red_magnet.png';
                                    break;
                                  case -4:
                                    imageUrl = 'assets/sticky_note.png';
                                    break;
                                  case -5:
                                    imageUrl = 'assets/sticky_note.png';
                                    color = Colors.pinkAccent;
                                    break;
                                  case -6:
                                    imageUrl = 'assets/sticky_note.png';
                                    color = Colors.lightBlue;
                                    break;
                                }

                                final newMagnet = Magnet(
                                  fridgeId: widget.fridge.id!,
                                  userId: authProvider.username,
                                  text: null,
                                  color: color,
                                  x: localOffset.dx,
                                  y: localOffset.dy,
                                  imageUrl: imageUrl,
                                );

                                // Optimistically show it right away
                                setState(() => _magnets.add(newMagnet));

                                try {
                                  final createdMagnetId = await MagnetService().createMagnet(authProvider.token!, newMagnet);
                                  setState(() {
                                    newMagnet.id = createdMagnetId;
                                    // Replace the temp magnet with the real one (with server ID)
                                    _magnets[_magnets.indexOf(newMagnet)] = newMagnet;
                                  });
                                } catch (e) {
                                  debugPrint('Failed to create magnet: $e');
                                  // Optionally revert UI change
                                  setState(() => _magnets.remove(newMagnet));
                                }

                              // Existing magnet moved
                              }
                              // Existing magnet moved
                              else {
                                final index = details.data;
                                if (index < 0 || index >= _magnets.length) return;

                                final magnet = _magnets[index];

                                final newX = localOffset.dx;
                                final newY = localOffset.dy;

                                setState(() {
                                  magnet.x = newX;
                                  magnet.y = newY;
                                });

                                try {
                                  if (magnet.id != null) {
                                    await MagnetService().updateMagnet(authProvider.token!, magnet);
                                  }
                                } catch (e) {
                                  debugPrint('Failed to update magnet: $e');
                                }
                              }
                            },
                            builder: (context, candidateData, rejectedData) {
                              return Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Image.asset(
                                    'assets/fridge.png',
                                    fit: BoxFit.cover,
                                  ),

                                  // Existing magnets (draggable)
                                  for (int i = 0; i < _magnets.length; i++)
                                    Positioned(
                                      left: (_magnets[i].x ?? 0) - 40,
                                      top: (_magnets[i].y ?? 0) - 40,
                                      child: Draggable<int>(
                                        data: i, // use index, not id
                                        feedback: SizedBox(
                                          width: 80,
                                          height: 80,
                                          child: _magnets[i].color == Colors.transparent ? Image.asset(_magnets[i].imageUrl ?? '') : ColorFiltered(colorFilter: ColorFilter.mode(_magnets[i].color!, BlendMode.srcIn), child: Image.asset(_magnets[i].imageUrl ?? ''),),
                                        ),
                                        childWhenDragging: const SizedBox(width: 80, height: 80),
                                        child: SizedBox(
                                          width: 80,
                                          height: 80,
                                          child: _magnets[i].color == Colors.transparent ? Image.asset(_magnets[i].imageUrl ?? '') : ColorFiltered(colorFilter: ColorFilter.mode(_magnets[i].color!, BlendMode.srcIn), child: Image.asset(_magnets[i].imageUrl ?? ''),),
                                        ),
                                      ),
                                    )
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Floating TRASH BIN (bottom-right corner)
          Positioned(
            bottom: 30,
            right: 30,
            child: DragTarget<int>(
              onWillAccept: (index) {
                if (index != null && index >= 0 && index < _magnets.length) {
                  setState(() => isTrashActive = true);
                  return true;
                }
                return false;
              },
              onLeave: (_) {
                setState(() => isTrashActive = false);
              },
              onAccept: (index) async {
                if (index < 0 || index >= _magnets.length) return; // safety check

                final removedMagnet = _magnets[index];

                // Optimistically remove it
                setState(() {
                  _magnets.removeAt(index);
                  isTrashActive = false;
                });

                try {
                  if (removedMagnet.id != null) {
                    await MagnetService().deleteMagnet(authProvider.token!, removedMagnet);
                  }
                } catch (e) {
                  debugPrint('Failed to delete magnet: $e');
                  // Rollback UI if backend fails
                  setState(() => _magnets.insert(index, removedMagnet));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to delete magnet.'))
                  );
                }
              },
              builder: (context, candidateData, rejectedData) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 100,
                  width: 120,
                  decoration: BoxDecoration(
                    color: isTrashActive
                        ? Colors.redAccent.withOpacity(0.9)
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      if (isTrashActive)
                        BoxShadow(
                          color: Colors.red.withOpacity(0.5),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.delete,
                        size: 40,
                        color: isTrashActive
                            ? Colors.white
                            : Colors.grey.shade700,
                      ),
                      Text(
                        "Trash",
                        style: TextStyle(
                          color: isTrashActive
                              ? Colors.white
                              : Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
