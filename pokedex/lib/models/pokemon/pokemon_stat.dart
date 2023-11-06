class Stat {
  final String name;

  const Stat({
    required this.name,
  });

  factory Stat.fromJson(Map<String, dynamic> json) {
    return Stat(
        name: json['name'] as String,
    );
  }
}