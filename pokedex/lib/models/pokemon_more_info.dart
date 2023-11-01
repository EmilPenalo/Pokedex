import 'package:pokedex/models/pokemon_abilities.dart';
import 'package:pokedex/models/pokemon_moves.dart';
import 'package:pokedex/models/pokemon_species.dart';
import 'package:pokedex/models/pokemon_stats.dart';

class PokemonMoreInfo {
  final Species species;
  final int height;
  final int weight;
  final List<Stats> stats;
  final List<Abilities> abilities;
  final List<Moves> moves;

  const PokemonMoreInfo({
    required this.species,
    required this.height,
    required this.weight,
    required this.stats,
    required this.abilities,
    required this.moves,
  });

  factory PokemonMoreInfo.fromJson(Map<String, dynamic> json) {
    Species species = Species.fromJson(json['species'] as Map<String, dynamic>);

    var statsList = json['stats'] as List;
    List<Stats> stats = statsList.map((entry) => Stats.fromJson(entry)).toList();

    var abilitiesList = json['abilities'] as List;
    List<Abilities> abilities = abilitiesList.map((entry) => Abilities.fromJson(entry)).toList();

    var movesList = json['moves'] as List;
    List<Moves> moves = movesList.map((entry) => Moves.fromJson(entry)).toList();

    return PokemonMoreInfo(
      species: species,
      height: json['height'] as int,
      weight: json['weight'] as int,
      stats: stats,
      abilities: abilities,
      moves : moves,
    );
  }
}