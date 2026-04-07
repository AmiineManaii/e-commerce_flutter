import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game.dart';
import '../services/api_service.dart';

class CartItem {
  final Game game;
  int quantity;

  CartItem({required this.game, this.quantity = 1});

  Map<String, dynamic> toJson() {
    return {'game': game.toJson(), 'quantity': quantity};
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      game: Game.fromJson(json['game']),
      quantity: json['quantity'],
    );
  }
}

class CartProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final Map<String, CartItem> _items = {};

  CartProvider() {
    _loadCart();
  }

  Map<String, CartItem> get items => _items;

  int get itemCount => _items.length;

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.game.price * cartItem.quantity;
    });
    return total;
  }

  Future<void> _saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = json.encode(
      _items.values.map((item) => item.toJson()).toList(),
    );
    prefs.setString('cart_data', cartData);
  }

  Future<void> _loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('cart_data')) {
      final cartData =
          json.decode(prefs.getString('cart_data')!) as List<dynamic>;
      _items.clear();
      for (var itemJson in cartData) {
        final cartItem = CartItem.fromJson(itemJson);
        _items.putIfAbsent(cartItem.game.id, () => cartItem);
      }
      notifyListeners();
    }
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
      _items.putIfAbsent(game.id, () => CartItem(game: game));
    }
    notifyListeners();
    _saveCart();
  }

  void removeItem(String gameId) {
    _items.remove(gameId);
    notifyListeners();
    _saveCart();
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
    _saveCart();
  }

  void clear() {
    _items.clear();
    notifyListeners();
    _saveCart();
  }

  Future<bool> checkout(String userId) async {
    if (_items.isEmpty) return false;

    try {
      final orderData = {
        'userId': userId,
        'date': DateTime.now().toIso8601String(),
        'total': totalAmount,
        'items': _items.values
            .map(
              (item) => {
                'gameId': item.game.id,
                'quantity': item.quantity,
                'price': item.game.price,
              },
            )
            .toList(),
      };

      final success = await _apiService.createOrder(orderData);
      if (success) {
        clear(); // Clear cart and save after successful checkout
      }
      return success;
    } catch (e) {
      debugPrint('Checkout error: $e');
      return false;
    }
  }
}
