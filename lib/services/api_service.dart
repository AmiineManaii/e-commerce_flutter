import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/game.dart';
import '../models/user.dart';

class ApiService {
  static const String baseUrl = 'https://e-commerce-3qt8.onrender.com';

  // --- Games ---
  Future<List<Game>> getGames() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/games'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Game.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load games');
      }
    } catch (e) {
      throw Exception('Error fetching games: $e');
    }
  }

  Future<Game> getGameById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/games/$id'));
    if (response.statusCode == 200) {
      return Game.fromJson(json.decode(response.body));
    } else {
      throw Exception('Game not found');
    }
  }

  // --- Authentication ---
  Future<User?> login(String email, String password) async {
    final response = await http.get(Uri.parse('$baseUrl/users?email=$email&password=$password'));
    if (response.statusCode == 200) {
      List<dynamic> users = json.decode(response.body);
      if (users.isNotEmpty) {
        return User.fromJson(users.first);
      }
    }
    return null;
  }

  Future<User?> register(User user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toJson()),
    );
    if (response.statusCode == 201) {
      return User.fromJson(json.decode(response.body));
    }
    return null;
  }
}
