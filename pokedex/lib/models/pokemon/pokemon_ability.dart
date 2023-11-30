class Ability {
  final String name;
  final String url;

  const Ability({
    required this.name,
    required this.url,
  });

  factory Ability.fromJson(Map<String, dynamic> json) {
    return Ability(
      name: json['name'] as String,
      url: json['url'] as String,
    );
  }
}