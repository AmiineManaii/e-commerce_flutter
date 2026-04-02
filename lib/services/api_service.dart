import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/game.dart';
import '../models/user.dart';
import '../models/review.dart';
import '../models/order.dart';

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
    final response = await http.get(
      Uri.parse('$baseUrl/users?email=$email&password=$password'),
    );
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

  // --- Orders ---
  Future<bool> createOrder(Map<String, dynamic> orderData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/orders'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(orderData),
    );
    return response.statusCode == 201;
  }

  Future<List<Order>> getUserOrders(String userId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/orders?userId=$userId'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Order.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // --- Reviews ---
  Future<List<Review>> getReviewsByGameId(String gameId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/reviews?gameId=$gameId'),
      );
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Review.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<bool> postReview(Review review) async {
    final response = await http.post(
      Uri.parse('$baseUrl/reviews'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(review.toJson()),
    );
    return response.statusCode == 201;
  }
}
