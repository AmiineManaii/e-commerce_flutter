import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';
import '../providers/user_provider.dart';
import '../providers/game_provider.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.isAuthenticated) {
      Future.microtask(() =>
          Provider.of<OrderProvider>(context, listen: false)
              .fetchUserOrders(userProvider.user!.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final gameProvider = Provider.of<GameProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Mes Commandes')),
      body: orderProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : orderProvider.orders.isEmpty
              ? const Center(child: Text('Aucune commande passée.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: orderProvider.orders.length,
                  itemBuilder: (ctx, i) {
                    final order = orderProvider.orders[i];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ExpansionTile(
                        title: Text(
                          'Commande #${order.id.length > 8 ? order.id.substring(0, 8) : order.id}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Date: ${order.date.contains('T') ? order.date.split('T')[0] : order.date} | Total: ${order.total.toStringAsFixed(2)} DT',
                        ),
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: order.items.length,
                            itemBuilder: (ctx, j) {
                              final item = order.items[j];
                              final game = gameProvider.games.firstWhere(
                                (g) => g.id == item.gameId,
                                orElse: () => gameProvider.games.first,
                              );
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(game.coverImage),
                                ),
                                title: Text(game.title),
                                subtitle: Text(
                                    '${item.quantity} x ${item.price.toStringAsFixed(2)} DT'),
                                trailing: Text(
                                  '${(item.quantity * item.price).toStringAsFixed(2)} DT',
                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
