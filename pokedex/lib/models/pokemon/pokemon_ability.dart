class Ability {
  final String name;

  const Ability({
    required this.name,
  });

  factory Ability.fromJson(Map<String, dynamic> json) {
    return Ability(
      name: json['name'] as String,
    );
  }
}