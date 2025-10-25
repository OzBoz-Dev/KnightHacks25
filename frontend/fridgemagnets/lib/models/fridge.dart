import 'package:fridgemagnets/models/magnet.dart';

class Fridge {
  final int id;
  String? user_id; // who own the fridge
  String name;
  List<Magnet> magnets;

  Fridge({
    required this.id,
    this.user_id,
    required this.name,
    required this.magnets
  });
}