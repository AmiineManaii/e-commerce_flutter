class Game {
  final String id;
  final String title;
  final String platform;
  final String genre;
  final double price;
  final double rating;
  final String releaseDate;
  final int stock;
  final String description;
  final String coverImage;
  final List<String> images;
  final String urlTrailer;
  final bool promo;
  final bool popular;
  final List<String> tags;

  Game({
    required this.id,
    required this.title,
    required this.platform,
    required this.genre,
    required this.price,
    required this.rating,
    required this.releaseDate,
    required this.stock,
    required this.description,
    required this.coverImage,
    required this.images,
    required this.urlTrailer,
    required this.promo,
    required this.popular,
    required this.tags,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'].toString(),
      title: json['title'],
      platform: json['platform'],
      genre: json['genre'],
      price: (json['price'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      releaseDate: json['release_date'],
      stock: json['stock'],
      description: json['description'],
      coverImage: json['cover_image'].toString().trim().replaceAll('`', ''),
      images: List<String>.from(json['images']).map((e) => e.trim().replaceAll('`', '')).toList(),
      urlTrailer: json['url_trailer'].toString().trim().replaceAll('`', ''),
      promo: json['promo'],
      popular: json['popular'],
      tags: List<String>.from(json['tags']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'platform': platform,
      'genre': genre,
      'price': price,
      'rating': rating,
      'release_date': releaseDate,
      'stock': stock,
      'description': description,
      'cover_image': coverImage,
      'images': images,
      'url_trailer': urlTrailer,
      'promo': promo,
      'popular': popular,
      'tags': tags,
    };
  }
}
