import 'package:pokedex/models/species/pokemon_species_egg_groups.dart';
import 'package:pokedex/models/species/pokemon_species_flavor_text_entries.dart';

class PokemonSpeciesInfo {
  final List<EggGroups> eggGroups;
  final FlavorTextEntries? firstEnglishFlavorText;
  final String evolutionChainUrl;
  final String habitat;

  const PokemonSpeciesInfo({
    required this.eggGroups,
    required this.firstEnglishFlavorText,
    required this.evolutionChainUrl,
    required this.habitat
  });

  factory PokemonSpeciesInfo.fromJson(Map<String, dynamic> json) {
    var eggGroupsList = json['egg_groups'] as List;
    List<EggGroups> eggGroups = eggGroupsList.map((entry) => EggGroups.fromJson(entry)).toList();

    var flavorTextEntriesList = json['flavor_text_entries'] as List;
    List<FlavorTextEntries> flavorTextEntries = flavorTextEntriesList.map((entry) => FlavorTextEntries.fromJson(entry)).toList();

    FlavorTextEntries? firstEnglishFlavorText;

    for (var entry in flavorTextEntries) {
      if (entry.language == "en") {
        firstEnglishFlavorText = entry;
        break;
      }
    }

    return PokemonSpeciesInfo(
        eggGroups: eggGroups,
        firstEnglishFlavorText: firstEnglishFlavorText,
        evolutionChainUrl: json['evolution_chain']['url'] as String,
        habitat: (json['habitat'] != null ? json['habitat']['name'] : "None") as String
    );
  }
}