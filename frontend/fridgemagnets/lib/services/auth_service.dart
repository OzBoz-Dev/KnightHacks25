import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fridgemagnets/consts.dart';

class AuthService {
  
  final String endpoint = "${AppConstants.apiUrl}/users/";
  
  // /api/users/register/
  // Create user
  Future<void> register(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse("${endpoint}register/"),
        headers: {
          "Content-Type": "application/json",
        },
        body:
          jsonEncode({
            "username": username,
            "password": password
          })
      );
      if(response.statusCode == 201) {
        return;
      }
      else if(response.statusCode == 409) {
        throw "This account already exists. Use the login page to acess your account!";
      }
      else {
        throw "An unexpected error occurred. Please try again later.";
      }
    }
    catch(e) {
      rethrow;
    }
  }
  
  // /api/users/login/
  // Log user in
  Future<String> login(String username, String password) async {
    try {
      final response = await http.post(Uri.parse("${endpoint}login/"),
        headers: {
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          "username": username,
          "password": password
        })
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['token'];
      }
      else if(response.statusCode == 401) {
        throw "Invalid username/password. Try again.";
      }
      else {
        throw "Failed to log in. Please try again later.";
      }
    }
    catch(e) {
      rethrow;
    }
  }

  // /api/users/ 
  // Get username from token
  Future<String> getUserName(String? token) async {
    if(token == null) {
      throw Exception("No token");
    }
    else {
      try {
        final response = await http.get(
          Uri.parse("$endpoint?token=$token"),
          headers: {
            "Content-Type": "application-json"
          }
        );
        if(response.statusCode == 200) {
          print("Status code: 200 OK");
          return jsonDecode(response.body)['username'];
        }
        if(response.statusCode == 404) {
          throw Exception("Error: User not found");
        }
        else {
          throw Exception("Failed to get user: ${response.statusCode} ${response.body}");
        }
      }
      catch(e) {
        throw Exception("Error: ${e.toString()}");
      }
    }
  }

  // Delete account
  Future<void> deleteAccount(String? token) async {
    if(token == null) {
      throw Exception("No token");
    }
    try {
      final response = await http.delete(
        Uri.parse(endpoint),
        headers: {
          "Content-Type": "application/json",
        },
        body:
          jsonEncode({
            "token": token
          })
      );
      if (response.statusCode == 200) {
        print("Status code: 200 OK");
        return;
      } else {
        throw Exception('Failed to delete account: ${response.statusCode} ${response.body}');
      }
    }
    catch(e) {
      throw Exception("Error: ${e.toString()}");
    }
  }
}