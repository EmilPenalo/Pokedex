class Species {
  final String name;
  final String url;

  const Species({
    required this.name,
    required this.url
  });

  factory Species.fromJson(Map<String, dynamic> json) {
    return Species(
        name: json['name'] as String,
        url: json['url'] as String
    );
  }
}