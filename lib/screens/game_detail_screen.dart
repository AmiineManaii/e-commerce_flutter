import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce/models/game.dart';
import 'package:e_commerce/models/review.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../providers/cart_provider.dart';
import '../providers/user_provider.dart';
import '../services/api_service.dart';

class GameDetailScreen extends StatefulWidget {
  final Game game;

  const GameDetailScreen({super.key, required this.game});

  @override
  State<GameDetailScreen> createState() => _GameDetailScreenState();
}

class _GameDetailScreenState extends State<GameDetailScreen> {
  late YoutubePlayerController _controller;
  final ApiService _apiService = ApiService();
  List<Review> _reviews = [];
  bool _isLoadingReviews = true;
  final _reviewController = TextEditingController();
  int _userRating = 5;

  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayer.convertUrlToId(widget.game.urlTrailer);
    _controller = YoutubePlayerController(
      initialVideoId: videoId ?? '',
      flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
    );
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    final reviews = await _apiService.getReviewsByGameId(widget.game.id);
    if (mounted) {
      setState(() {
        _reviews = reviews;
        _isLoadingReviews = false;
      });
    }
  }

  void _submitReview() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (!userProvider.isAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Connectez-vous pour laisser un avis')),
      );
      return;
    }

    if (_reviewController.text.isEmpty) return;

    final newReview = Review(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      gameId: widget.game.id,
      userId: userProvider.user!.id,
      msg: _reviewController.text,
      note: _userRating,
      date: DateTime.now().toIso8601String(),
      verified: true,
    );

    final success = await _apiService.postReview(newReview);
    if (success) {
      _reviewController.clear();
      _loadReviews();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Avis publié !')));
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text(widget.game.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: widget.game.coverImage,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.game.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${widget.game.price} €',
                        style: const TextStyle(
                          fontSize: 22,
                          color: Colors.indigoAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text('${widget.game.rating}'),
                      const SizedBox(width: 16),
                      Text(
                        widget.game.platform,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Description',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(widget.game.description),
                  const SizedBox(height: 24),
                  const Text(
                    'Trailer',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  YoutubePlayer(
                    controller: _controller,
                    showVideoProgressIndicator: true,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Laisser un avis',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  if (userProvider.isAuthenticated) ...[
                    Row(
                      children: List.generate(5, (index) {
                        return IconButton(
                          icon: Icon(
                            index < _userRating
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                          ),
                          onPressed: () =>
                              setState(() => _userRating = index + 1),
                        );
                      }),
                    ),
                    TextField(
                      controller: _reviewController,
                      decoration: const InputDecoration(
                        hintText: 'Votre avis...',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _submitReview,
                      child: const Text('Envoyer'),
                    ),
                  ] else
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/login'),
                      child: const Text('Connectez-vous pour laisser un avis'),
                    ),
                  const SizedBox(height: 24),
                  const Text(
                    'Avis des joueurs',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _isLoadingReviews
                      ? const Center(child: CircularProgressIndicator())
                      : _reviews.isEmpty
                      ? const Text('Aucun avis pour le moment.')
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _reviews.length,
                          itemBuilder: (ctx, i) {
                            final review = _reviews[i];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                title: Row(
                                  children: [
                                    ...List.generate(
                                      5,
                                      (index) => Icon(
                                        Icons.star,
                                        size: 16,
                                        color: index < review.note
                                            ? Colors.amber
                                            : Colors.grey,
                                      ),
                                    ),
                                    const Spacer(),
                                    if (review.verified)
                                      const Icon(
                                        Icons.verified,
                                        color: Colors.blue,
                                        size: 16,
                                      ),
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 8),
                                    Text(review.msg),
                                    const SizedBox(height: 4),
                                    Text(
                                      review.date.split('T')[0],
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        cartProvider.addItem(widget.game);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${widget.game.title} ajouté au panier',
                            ),
                          ),
                        );
                      },
                      child: const Text('AJOUTER AU PANIER'),
                    ),
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
