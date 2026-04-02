import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game.dart';
import '../providers/cart_provider.dart';
import '../providers/user_provider.dart';
import '../screens/game_detail_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class GameCard extends StatelessWidget {
  final Game game;

  const GameCard({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (ctx) => GameDetailScreen(game: game)),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(15),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: game.coverImage,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (ctx, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (ctx, url, error) => const Icon(Icons.error),
                    ),
                  ),
                  if (game.promo)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Text(
                          'PROMO',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ),
                  Positioned(
                    top: 5,
                    left: 5,
                    child: CircleAvatar(
                      backgroundColor: Colors.black.withOpacity(0.5),
                      radius: 18,
                      child: IconButton(
                        iconSize: 18,
                        icon: Icon(
                          userProvider.isFavorite(game.id)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: userProvider.isFavorite(game.id)
                              ? Colors.red
                              : Colors.white,
                        ),
                        onPressed: () {
                          if (!userProvider.isAuthenticated) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Veuillez vous connecter pour ajouter aux favoris'),
                              ),
                            );
                            return;
                          }
                          userProvider.toggleWishlist(game.id);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    game.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    game.genre,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${game.price} DT',
                        style: const TextStyle(
                          color: Colors.indigoAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.add_shopping_cart,
                          color: Colors.indigo,
                        ),
                        onPressed: () {
                          cartProvider.addItem(game);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${game.title} ajouté au panier'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
