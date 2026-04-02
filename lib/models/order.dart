class OrderItem {
  final String gameId;
  final int quantity;
  final double price;

  OrderItem({
    required this.gameId,
    required this.quantity,
    required this.price,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      gameId: json['gameId'].toString(),
      quantity: json['quantity'],
      price: (json['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gameId': gameId,
      'quantity': quantity,
      'price': price,
    };
  }
}

class Order {
  final String id;
  final String userId;
  final String date;
  final double total;
  final List<OrderItem> items;

  Order({
    required this.id,
    required this.userId,
    required this.date,
    required this.total,
    required this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'].toString(),
      userId: json['userId'].toString(),
      date: json['date'] ?? '',
      total: (json['total'] as num).toDouble(),
      items: (json['items'] as List<dynamic>?)
          ?.map((item) => OrderItem.fromJson(item))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'date': date,
      'total': total,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}
