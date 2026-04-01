import 'package:flutter/material.dart';
import '../models/game.dart';
import '../services/api_service.dart';

class GameProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Game> _games = [];
  bool _isLoading = false;

  List<Game> get games => _games;
  bool get isLoading => _isLoading;

  Future<void> fetchGames() async {
    _isLoading = true;
    notifyListeners();
    try {
      _games = await _apiService.getGames();
    } catch (e) {
      print('Error fetching games: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Game> get popularGames => _games.where((game) => game.popular).toList();
  List<Game> get promoGames => _games.where((game) => game.promo).toList();

  List<Game> filterByGenre(String genre) {
    return _games.where((game) => game.genre == genre).toList();
  }

  List<Game> searchGames(String query) {
    return _games
        .where(
          (game) =>
              game.title.toLowerCase().contains(query.toLowerCase()) ||
              game.genre.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }
}
