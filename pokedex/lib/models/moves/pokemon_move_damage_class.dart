class DamageClass {
  final String name;

  const DamageClass({
    required this.name,
  });

  factory DamageClass.fromJson(Map<String, dynamic> json) {
    return DamageClass(
      name: json['name'] as String,
    );
  }
}