class User {
  final String id;
  final String nom;
  final String prenom;
  final String email;
  final String password;
  final String adresse;
  final List<String>? wishlist;

  User({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.password,
    required this.adresse,
    this.wishlist,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      nom: json['nom'] ?? json['name'] ?? '',
      prenom: json['prenom'] ?? '',
      email: json['email'],
      password: json['password'],
      adresse: json['adresse'] ?? '',
      wishlist: json['wishlist'] != null ? List<String>.from(json['wishlist']) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'password': password,
      'adresse': adresse,
      'wishlist': wishlist,
    };
  }
}
