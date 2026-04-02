class Review {
  final String id;
  final String gameId;
  final String userId;
  final String msg;
  final int note;
  final String date;
  final bool verified;

  Review({
    required this.id,
    required this.gameId,
    required this.userId,
    required this.msg,
    required this.note,
    required this.date,
    required this.verified,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      gameId: json['gameId'],
      userId: json['userId'],
      msg: json['msg'],
      note: json['note'],
      date: json['date'],
      verified: json['verified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gameId': gameId,
      'userId': userId,
      'msg': msg,
      'note': note,
      'date': date,
      'verified': verified,
    };
  }
}
