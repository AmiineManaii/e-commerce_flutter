import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../providers/game_provider.dart';
import '../widgets/game_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final gameProvider = Provider.of<GameProvider>(context);
    final user = userProvider.user;

    if (!userProvider.isAuthenticated) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profil')),
        body: Center(
          child: ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/login'),
            child: const Text('Se connecter'),
          ),
        ),
      );
    }

    final favoriteGames = gameProvider.games
        .where((g) => userProvider.isFavorite(g.id))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Profil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () {
              userProvider.logout();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    child: Icon(Icons.person, size: 50),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${user!.prenom} ${user.nom}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(user.email, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Mes Informations',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildInfoTile('Adresse par défaut', user.adresse),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.history, color: Colors.indigoAccent),
              title: const Text('Mon Historique de Commandes'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => Navigator.pushNamed(context, '/orders'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              tileColor: Colors.white.withOpacity(0.05),
            ),
            const SizedBox(height: 30),
            const Text(
              'Ma Liste de Souhaits (Wishlist)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            favoriteGames.isEmpty
                ? const Text('Aucun favori pour le moment.')
                : SizedBox(
                    height: 250,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: favoriteGames.length,
                      itemBuilder: (ctx, i) {
                        return SizedBox(
                          width: 180,
                          child: GameCard(game: favoriteGames[i]),
                        );
                      },
                    ),
                  ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
