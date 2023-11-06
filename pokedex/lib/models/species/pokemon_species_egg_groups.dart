class EggGroups {
  final String name;

  EggGroups({
    required this.name,
  });

  factory EggGroups.fromJson(Map<String, dynamic> json) {
    return EggGroups(
        name: json['name'] as String,
    );
  }
}