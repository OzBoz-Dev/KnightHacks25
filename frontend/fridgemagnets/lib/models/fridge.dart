import 'package:fridgemagnets/models/magnet.dart';

class Fridge {
  final int id;
  String name;
  List<Magnet> magnets;

  Fridge({
    required this.id,
    required this.name,
    required this.magnets
  });
}