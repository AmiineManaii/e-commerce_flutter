import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

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
                        subtitle: Text('${item.quantity} x ${item.game.price} €'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => cartProvider.removeItem(item.game.id),
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
                        'Total: ${cartProvider.totalAmount.toStringAsFixed(2)} €',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // TODO: Implement checkout
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Commande en cours...')),
                          );
                          cartProvider.clear();
                          Navigator.pop(context);
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
