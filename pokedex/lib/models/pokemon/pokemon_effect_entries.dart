class EffectEntries {
  final String effect;
  final String shortEffect;
  final String language;

  const EffectEntries({
    required this.effect,
    required this.shortEffect,
    required this.language,
  });

  factory EffectEntries.fromJson(Map<String, dynamic> json) {
    return EffectEntries(
        effect: json['effect'] as String,
        shortEffect: json['short_effect'] as String,
        language: json['language']['name'] as String
    );
  }
}