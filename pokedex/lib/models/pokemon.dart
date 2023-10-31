class Pokemon {
  final String name;
  final String url;

  const Pokemon({
    required this.name,
    required this.url
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
        name: json['name'] as String,
        url: json['url'] as String
    );
  }
}