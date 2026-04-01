import 'package:flutter/material.dart';
import '../models/game.dart';

class CartItem {
  final Game game;
  int quantity;

  CartItem({required this.game, this.quantity = 1});
}

class CartProvider with ChangeNotifier {
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
}
