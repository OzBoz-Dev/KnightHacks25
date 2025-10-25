import 'package:flutter/widgets.dart';

class Magnet {
  final int id;
  final int fridgeId;
  final String? userId; // the user who placed the magnet
  String? text;
  Color? color; // from hex code
  double? x;
  double? y;
  String? imageUrl;

  Magnet({
    required this.id,
    required this.fridgeId,
    required this.userId,
    required this.text,
    required this.color,
    required this.x,
    required this.y,
    required this.imageUrl,
  });
}
