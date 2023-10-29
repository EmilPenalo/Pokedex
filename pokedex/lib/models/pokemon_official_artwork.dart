class OfficialArtwork {
  final String frontDefault;

  const OfficialArtwork({
    required this.frontDefault,
  });

  factory OfficialArtwork.fromJson(Map<String, dynamic> json) {
    return OfficialArtwork(
      frontDefault: json['front_default'] as String,
    );
  }
}