class FlavorTextEntries {
  final String flavorText;

  const FlavorTextEntries({
    required this.flavorText,
  });

  factory FlavorTextEntries.fromJson(Map<String, dynamic> json) {
    return FlavorTextEntries(
      flavorText: json['flavor_text'] as String,
    );
  }
}