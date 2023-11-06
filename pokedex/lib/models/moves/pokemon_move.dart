class Move {
  final String name;
  final String url;

  const Move({
    required this.name,
    required this.url,
  });

  factory Move.fromJson(Map<String, dynamic> json) {
    return Move(
      name: json['name'] as String,
      url: json['url'] as String,
    );
  }
}