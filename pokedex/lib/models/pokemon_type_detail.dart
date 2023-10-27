class TypeDetail {
  final String name;

  const TypeDetail({
    required this.name,
  });

  factory TypeDetail.fromJson(Map<String, dynamic> json) {
    return TypeDetail(
      name: json['name'] as String,
    );
  }
}