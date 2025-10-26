import 'dart:convert';
import 'dart:ui';

import 'package:fridgemagnets/consts.dart';
import 'package:fridgemagnets/models/fridge.dart';
import 'package:fridgemagnets/models/magnet.dart';
import 'package:http/http.dart' as http;

class FridgeService {

  final String endpoint = "${AppConstants.apiUrl}/fridges/";

  // Gets list of fridges
  // Future<List<Fridge>> getFridges() async {
  //   try {
  //     final response = await http.get(Uri.parse(endpoint));
  //     final decoded = jsonDecode(response.body) as List<dynamic>;
  //     List<Fridge> fridges = decoded.map((e) => e as Map<String, dynamic>).map((fridge) => Fridge(
  //       id: fridge['fridge_id'],
  //       name: fridge['name'],
  //       magnets: (fridge['magnets'] as List<dynamic>).map((magnet) => Magnet(
  //         id: magnet['id'],
  //         fridgeId: magnet['fridge_id'],
  //         userId: magnet['user_id'],
  //         text: magnet['text'],
  //         color: magnet['color'],
  //         x: magnet['x'],
  //         y: magnet['y'],
  //         imageUrl: magnet['image_url'],
  //       )).toList(),
  //     )).toList();
  //     return fridges;
  //   }
  //   catch(e) {
  //     throw Exception(e);
  //   }
  // }

  Future<List<Fridge>> getFridgesByUsername(String username) async {
    try {
      final response = await http.get(Uri.parse("$endpoint?user_id=$username"));

      final decoded = jsonDecode(response.body) as List<dynamic>;

      List<Fridge> fridges = decoded.map((fridge) {
        final fridgeMap = fridge as Map<String, dynamic>;

        List<Magnet> magnets = (fridgeMap['magnets'] as List<dynamic>).map((magnet) {
          final magnetMap = magnet as Map<String, dynamic>;
          return Magnet(
            id: magnetMap['id'],
            fridgeId: magnetMap['fridge_id'],
            userId: magnetMap['user_id'],
            text: magnetMap['text'],
            color: Color(int.parse(magnetMap['color'])),
            x: (magnetMap['x'] as num).toDouble(),
            y: (magnetMap['y'] as num).toDouble(),
            imageUrl: magnetMap['image_url'],
          );
        }).toList();

        return Fridge(
          id: fridgeMap['fridge_id'],
          name: fridgeMap['name'],
          magnets: magnets,
        );
      }).toList();

      return fridges;
    } catch (e) {
      throw Exception(e);
    }
  }


  // Creates a fridge
  Future<void> createFridge(Fridge fridge) async {
    try {
      final response = await http.post(
        Uri.parse(endpoint),
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
    }
    catch(e) {
      throw Exception(e);
    }
  }

  // Deletes a fridge
  Future<void> deleteFridge(Fridge fridge) async {
    try {
      final response = await http.delete(
        Uri.parse(endpoint),
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
    catch(e) {
      throw Exception(e);
    }
  }
}