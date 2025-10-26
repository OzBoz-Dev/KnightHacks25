import 'dart:convert';
import 'dart:ui';
import 'package:fridgemagnets/consts.dart';
import 'package:fridgemagnets/models/fridge.dart';
import 'package:fridgemagnets/models/magnet.dart';
import 'package:http/http.dart' as http;

class FridgeService {

  final String endpoint = "${AppConstants.apiUrl}/fridges/";

  Future<List<Fridge>> getFridgesByUsername(String username) async {
    try {
      final response = await http.get(Uri.parse("$endpoint?user_id=$username"));
      print(response.body);
      final decoded = jsonDecode(response.body) as List<dynamic>;
      if(decoded.isEmpty) {
        return [];
      }
      List<Fridge> fridges = decoded.map((fridge) => Fridge(
        id: fridge['fridge_id'],
        name: fridge['name'],
        magnets: (fridge['magnets'] as List<dynamic>).map((magnet) => Magnet(
          id: magnet['id'],
          fridgeId: magnet['fridge_id'],
          userId: magnet['user_id'], 
          text: magnet['text'],
          color: Color(int.parse(magnet['color'])),
          x: magnet['x'],
          y: magnet['y'],
          imageUrl: magnet['image_url']
        )).toList()
      )).toList();

      return fridges;
    } catch (e) {
      throw Exception(e);
    }
  }


  // Creates a fridge
  Future<void> createFridge(String token, String fridgeName, String username) async {
    try {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          "Content-Type" : "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          "name": fridgeName,
          "user_id": username
        })
      );
      if(response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception("Failed to create a Fridge - Status code: ${response.statusCode}");
      }
    }
    catch(e) {
      throw Exception(e);
    }
  }

  // Deletes a fridge
  Future<void> deleteFridge(String token, Fridge fridge) async {
    try {
      final response = await http.delete(
        Uri.parse(endpoint),
        headers: {
          "Content-Type" : "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          "fridge_id": fridge.id,
        })
      );
      if(response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception("Failed to delete Fridge - Status code: ${response.statusCode}");
      }
    }
    catch(e) {
      throw Exception(e);
    }
  }
}