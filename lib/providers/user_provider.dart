import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class UserProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  User? _user;
  bool _isLoading = false;

  UserProvider() {
    _loadUser();
  }

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('user_data')) {
      final userData = json.decode(prefs.getString('user_data')!);
      _user = User.fromJson(userData);
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      _user = await _apiService.login(email, password);
      if (_user != null) {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('user_data', json.encode(_user!.toJson()));
      }
      _isLoading = false;
      notifyListeners();
      return _user != null;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(User user) async {
    _isLoading = true;
    notifyListeners();
    try {
      final newUser = await _apiService.register(user);
      if (newUser != null) {
        _user = newUser;
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('user_data', json.encode(_user!.toJson()));
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('user_data');
    notifyListeners();
  }

  // --- Wishlist ---
  Future<void> toggleWishlist(String gameId) async {
    if (_user == null) return;

    final wishlist = List<String>.from(_user!.wishlist ?? []);
    if (wishlist.contains(gameId)) {
      wishlist.remove(gameId);
    } else {
      wishlist.add(gameId);
    }

    final updatedUser = User(
      id: _user!.id,
      nom: _user!.nom,
      prenom: _user!.prenom,
      email: _user!.email,
      password: _user!.password,
      adresse: _user!.adresse,
      wishlist: wishlist,
    );

    try {
      final response = await http.put(
        Uri.parse('${ApiService.baseUrl}/users/${_user!.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updatedUser.toJson()),
      );

      if (response.statusCode == 200) {
        _user = updatedUser;
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('user_data', json.encode(_user!.toJson()));
        notifyListeners();
      }
    } catch (e) {
      print('Error updating wishlist: $e');
    }
  }

  bool isFavorite(String gameId) {
    return _user?.wishlist?.contains(gameId) ?? false;
  }
}
