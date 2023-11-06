class FlavorTextEntries {
  final String flavorText;
  final String language;

  const FlavorTextEntries({
    required this.flavorText,
    required this.language,
  });

  factory FlavorTextEntries.fromJson(Map<String, dynamic> json) {
    final originalText = json['flavor_text'] as String;
    final cleanedText = originalText.replaceAll('\n', ' ');

    return FlavorTextEntries(
      flavorText: cleanedText,
      language: json['language']['name'] as String
    );
  }
}