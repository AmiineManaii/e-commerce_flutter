import 'package:flutter/material.dart';
import '../models/game.dart';
import '../services/api_service.dart';

class CartItem {
  final Game game;
  int quantity;

  CartItem({required this.game, this.quantity = 1});
}

class CartProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => _items;

  int get itemCount => _items.length;

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.game.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(Game game) {
    if (_items.containsKey(game.id)) {
      _items.update(
        game.id,
        (existingItem) => CartItem(
          game: existingItem.game,
          quantity: existingItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        game.id,
        () => CartItem(game: game),
      );
    }
    notifyListeners();
  }

  void removeItem(String gameId) {
    _items.remove(gameId);
    notifyListeners();
  }

  void removeSingleItem(String gameId) {
    if (!_items.containsKey(gameId)) return;
    if (_items[gameId]!.quantity > 1) {
      _items.update(
        gameId,
        (existingItem) => CartItem(
          game: existingItem.game,
          quantity: existingItem.quantity - 1,
        ),
      );
    } else {
      _items.remove(gameId);
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  Future<bool> checkout(String userId) async {
    if (_items.isEmpty) return false;

    try {
      final orderData = {
        'userId': userId,
        'date': DateTime.now().toIso8601String(),
        'total': totalAmount,
        'items': _items.values.map((item) => {
          'gameId': item.game.id,
          'quantity': item.quantity,
          'price': item.game.price,
        }).toList(),
      };

      final success = await _apiService.createOrder(orderData);
      if (success) {
        clear();
      }
      return success;
    } catch (e) {
      debugPrint('Checkout error: $e');
      return false;
    }
  }
}
