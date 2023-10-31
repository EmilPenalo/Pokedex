import 'package:pokedex/models/pokemon_species_flavor_text_entries.dart';

class PokemonSpeciesInfo {
  final FlavorTextEntries flavorTextEntries;

  const PokemonSpeciesInfo({
    required this.flavorTextEntries
  });

  factory PokemonSpeciesInfo.fromJson(Map<String, dynamic> json) {
    FlavorTextEntries flavorTextEntries = FlavorTextEntries.fromJson(json['flavor_text_entries'] as Map<String, dynamic>);

    return PokemonSpeciesInfo(
        flavorTextEntries: flavorTextEntries
    );
  }
}