class OfficialArtwork {
  final String? frontDefault;
  final String? frontShiny;

  const OfficialArtwork({
    this.frontDefault,
    this.frontShiny,
  });

  factory OfficialArtwork.fromJson(Map<String, dynamic> json) {
    return OfficialArtwork(
      frontDefault: json['front_default'] as String?,
      frontShiny: json['front_shiny'] as String?,
    );
  }
}