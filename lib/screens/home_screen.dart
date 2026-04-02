import 'package:e_commerce/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/game_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';
  String _selectedGenre = 'Tous';

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<GameProvider>(context, listen: false).fetchGames(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);

    final genres = [
      'Tous',
      ...Set.from(gameProvider.games.map((g) => g.genre)),
    ];

    final displayedGames = gameProvider.games.where((game) {
      final matchesSearch = game.title.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
      final matchesGenre =
          _selectedGenre == 'Tous' || game.genre == _selectedGenre;
      return matchesSearch && matchesGenre;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('GameMart 🎮'),
        actions: [
          IconButton(
            icon: Badge(
              label: Text(cartProvider.itemCount.toString()),
              child: const Icon(Icons.shopping_cart),
            ),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
          IconButton(
            icon: Icon(
              userProvider.isAuthenticated ? Icons.person : Icons.login,
            ),
            onPressed: () {
              if (userProvider.isAuthenticated) {
                Navigator.pushNamed(context, '/profile');
              } else {
                Navigator.pushNamed(context, '/login');
              }
            },
          ),
        ],
      ),
      body: gameProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => gameProvider.fetchGames(),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Rechercher un jeu...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          filled: true,
                        ),
                        onChanged: (val) => setState(() => _searchQuery = val),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: genres.length,
                        itemBuilder: (ctx, i) {
                          final genre = genres[i];
                          final isSelected = _selectedGenre == genre;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ChoiceChip(
                              label: Text(genre),
                              selected: isSelected,
                              onSelected: (selected) {
                                if (selected)
                                  setState(() => _selectedGenre = genre);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Catalogue des Jeux',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    displayedGames.isEmpty
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(40.0),
                              child: Text('Aucun jeu trouvé'),
                            ),
                          )
                        : GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.7,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                ),
                            itemCount: displayedGames.length,
                            itemBuilder: (ctx, i) {
                              return GameCard(game: displayedGames[i]);
                            },
                          ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }
}
