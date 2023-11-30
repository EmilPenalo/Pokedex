import 'package:pokedex/models/pokemon/pokemon_effect_entries.dart';

class PokemonAbilityInfo {
  final EffectEntries? firstEnglishEffect;

  const PokemonAbilityInfo({
    required this.firstEnglishEffect,
  });

  factory PokemonAbilityInfo.fromJson(Map<String, dynamic> json) {
    var effectEntriesList = json['effect_entries'] as List;
    List<EffectEntries> effectEntries = effectEntriesList.map((entry) => EffectEntries.fromJson(entry)).toList();

    EffectEntries? firstEnglishEffect;

    for (var entry in effectEntries) {
      if (entry.language == "en") {
        firstEnglishEffect = entry;
        break;
      }
    }

    return PokemonAbilityInfo(
      firstEnglishEffect: firstEnglishEffect,
    );
  }
}