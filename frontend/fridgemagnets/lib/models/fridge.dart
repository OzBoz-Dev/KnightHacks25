import 'package:fridgemagnets/models/magnet.dart';

class Fridge {
  int? id;
  String? userId; // who own the fridge
  String name;
  List<Magnet> magnets;

  Fridge({
    this.id,
    this.userId,
    required this.name,
    required this.magnets
  });
}