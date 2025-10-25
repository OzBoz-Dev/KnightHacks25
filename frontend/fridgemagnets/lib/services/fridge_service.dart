import 'dart:convert';
import 'dart:ui';

import 'package:fridgemagnets/models/fridge.dart';
import 'package:fridgemagnets/models/magnet.dart';
import 'package:http/http.dart' as http;

class FridgeService {

  final String url = "http://10.37.48.242:5000/api/fridges/";

  // Gets list of fridges
  Future<List<Fridge>> getFridges() async {
    final response = await http.get(Uri.parse(url));
    print(response.body);
    final decoded = jsonDecode(response.body) as List<dynamic>;
    List<Fridge> fridges = decoded.map((e) => e as Map<String, dynamic>).map((fridge) => Fridge(
      id: fridge['fridge_id'],
      name: fridge['name'],
      magnets: (fridge['magnets'] as List<dynamic>).map((magnet) => Magnet(
        id: magnet['id'],
        fridgeId: magnet['fridge_id'],
        userId: magnet['user_id'],
        text: magnet['text'],
        color: magnet['color'],
        x: magnet['x'],
        y: magnet['y'],
        imageUrl: magnet['image_url'],
      )).toList(),
    )).toList();
    return fridges;
  }

  Future<Fridge> getFridgeById(int fridgeId) async {
    final response = await http.get(Uri.parse("$url?id=$fridgeId"));
    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    Fridge fridge = Fridge(
      id: decoded['fridge_id'],
      name: decoded['name'],
      magnets: (decoded['magnets'] as List<dynamic>).map((magnet) => Magnet(
        id: magnet['id'],
        fridgeId: magnet['fridge_id'],
        userId: magnet['user_id'],
        text: magnet['text'],
        color: Color(int.parse(magnet['color'])),
        x: magnet['x'],
        y: magnet['y'],
        imageUrl: magnet['image_url'],
      )).toList(),
    );
    return fridge;
  }

  // Creates a fridge
  Future<void> createFridge(Fridge fridge) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type" : "application/json",
      },
      body: jsonEncode({
        "name": fridge.name,
        "user_id": fridge.user_id
      })
    );
    if(response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception("Failed to delete Fridge - Status code: ${response.statusCode}");
    }
    print("Status code: ${response.statusCode}");
  }

  // Deletes a fridge
  Future<void> deleteFridge(Fridge fridge) async {
    final response = await http.delete(
      Uri.parse(url),
      headers: {
        "Content-Type" : "application/json",
      },
      body: jsonEncode({
        "fridge_id": fridge.id
      })
    );
    if(response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception("Failed to delete Fridge - Status code: ${response.statusCode}");
    }
  }
}