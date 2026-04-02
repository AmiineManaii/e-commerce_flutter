import 'package:flutter/material.dart';
import '../models/order.dart';
import '../services/api_service.dart';

class OrderProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Order> _orders = [];
  bool _isLoading = false;

  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;

  Future<void> fetchUserOrders(String userId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _orders = await _apiService.getUserOrders(userId);
      // Sort by date (newest first)
      _orders.sort((a, b) {
        if (a.date == null || b.date == null) return 0;
        return b.date.compareTo(a.date);
      });
    } catch (e) {
      print('Error fetching orders: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void addOrder(Order order) {
    _orders.insert(0, order);
    notifyListeners();
  }
}
