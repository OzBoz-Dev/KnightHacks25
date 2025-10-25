import 'dart:convert';
import 'package:fridgemagnets/models/magnet.dart';
import 'package:http/http.dart' as http;

class MagnetService {

  final String url = "http://10.37.48.242:5000/api/magnets/";

  // GET magnets (localhost/api/magnets)
  Future<Magnet> getMagnetById({int magnetId = 0}) async {
    try {
      final response = await http.get(
        Uri.parse("$url?id=$magnetId"),
        headers: {
          "Content-Type": "application/json",
        },
      );
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      Magnet magnet = Magnet(
        id: decoded['id'],
        fridgeId: decoded['fridge_id'],
        userId: decoded['user_id'],
        text: decoded['text'],
        color: decoded['color'],
        x: decoded['x'],
        y: decoded['y'],
        imageUrl: decoded['image_url']
      );
      return magnet;
    }
    catch(e) {
      throw Exception(e);
    }
  }

  // POST magnet when placing
  Future<void> createMagnet(Magnet magnet) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          "fridge_id": magnet.fridgeId,
          "user_id": magnet.userId,
          "text": magnet.text,
          "color": magnet.color?.toARGB32(),
          "x": magnet.x,
          "y": magnet.y,
          "image_url": magnet.imageUrl,
        })
      );
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception('Failed to update magnet - Status Code: ${response.statusCode}');
      }
    }
    catch(e) {
      throw Exception(e);
    }
  }

  // PATCH magnet data when moving
  Future<void> updateMagnet(Magnet magnet) async {
    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          "id": magnet.id,
          "fridge_id": magnet.fridgeId,
          "user_id": magnet.userId,
          "text": magnet.text,
          "color": magnet.color?.toARGB32(),
          "x": magnet.x,
          "y": magnet.y,
          "image_url": magnet.imageUrl,
        })
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception('Failed to update magnet - Status Code: ${response.statusCode}');
      }
    }
    catch(e) {
      throw Exception(e);
    }
  }

  // DELETE magnet data when a magnet is deleted
  Future<void> deleteMagnet(Magnet magnet) async {
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "id": magnet.id
        })
      );

      if(response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception("Failed to delete magnet - Status Code: ${response.statusCode}");
      }
    }
    catch(e) {
      throw Exception(e);
    }
  }

}