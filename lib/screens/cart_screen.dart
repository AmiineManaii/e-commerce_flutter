import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/user_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Mon Panier')),
      body: cartProvider.items.isEmpty
          ? const Center(child: Text('Le panier est vide'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartProvider.items.length,
                    itemBuilder: (ctx, i) {
                      final item = cartProvider.items.values.toList()[i];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(item.game.coverImage),
                        ),
                        title: Text(item.game.title),
                        subtitle: Text('${item.quantity} x ${item.game.price} DT'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () => cartProvider.removeSingleItem(item.game.id),
                            ),
                            Text('${item.quantity}'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => cartProvider.addItem(item.game),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => cartProvider.removeItem(item.game.id),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total: ${cartProvider.totalAmount.toStringAsFixed(2)} DT',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (!userProvider.isAuthenticated) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Veuillez vous connecter pour commander')),
                            );
                            Navigator.pushNamed(context, '/login');
                            return;
                          }

                          final success = await cartProvider.checkout(userProvider.user!.id);
                          if (success && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Commande réussie !')),
                            );
                            Navigator.pop(context);
                          } else if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Échec de la commande')),
                            );
                          }
                        },
                        child: const Text('Commander'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
