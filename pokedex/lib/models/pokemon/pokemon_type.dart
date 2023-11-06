class Type {
  final String name;

  const Type({
    required this.name,
  });

  factory Type.fromJson(Map<String, dynamic> json) {
    return Type(
      name: json['name'] as String,
    );
  }
}