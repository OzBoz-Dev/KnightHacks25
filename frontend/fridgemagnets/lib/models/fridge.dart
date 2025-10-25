import 'package:fridgemagnets/models/magnet.dart';

class Fridge {
  final int id;
  final String username; // who own the fridge
  String name;
  List<Magnet> magnets;

  Fridge({
    required this.id,
    required this.username,
    required this.name,
    required this.magnets
  });
}