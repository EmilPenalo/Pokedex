class MoveEffectEntries {
  final String effect;

  const MoveEffectEntries({
    required this.effect,
  });

  factory MoveEffectEntries.fromJson(Map<String, dynamic> json) {
    return MoveEffectEntries(
      effect: json['effect_entries'][0]['effect'] as String,
    );
  }
}