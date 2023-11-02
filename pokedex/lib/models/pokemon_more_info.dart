import 'package:pokedex/models/pokemon_abilities.dart';
import 'package:pokedex/models/pokemon_moves.dart';
import 'package:pokedex/models/pokemon_species.dart';
import 'package:pokedex/models/pokemon_sprites.dart';
import 'package:pokedex/models/pokemon_stats.dart';
import 'package:pokedex/models/pokemon_types.dart';

class PokemonMoreInfo {
  final Sprites sprites;
  final List<Types> types;
  final Species species;
  final int height;
  final int weight;
  final List<Stats> stats;
  final List<Abilities> abilities;
  final List<Moves> moves;

  const PokemonMoreInfo({
    required this.sprites,
    required this.types,
    required this.species,
    required this.height,
    required this.weight,
    required this.stats,
    required this.abilities,
    required this.moves,
  });

  factory PokemonMoreInfo.fromJson(Map<String, dynamic> json) {
    Sprites sprites = Sprites.fromJson(json['sprites'] as Map<String, dynamic>);

    var typesList = json['types'] as List;
    List<Types> types = typesList.map((entry) => Types.fromJson(entry)).toList();

    Species species = Species.fromJson(json['species'] as Map<String, dynamic>);

    var statsList = json['stats'] as List;
    List<Stats> stats = statsList.map((entry) => Stats.fromJson(entry)).toList();

    var abilitiesList = json['abilities'] as List;
    List<Abilities> abilities = abilitiesList.map((entry) => Abilities.fromJson(entry)).toList();

    var movesList = json['moves'] as List;
    List<Moves> moves = movesList.map((entry) => Moves.fromJson(entry)).toList();

    return PokemonMoreInfo(
      sprites: sprites,
      types: types,
      species: species,
      height: json['height'] as int,
      weight: json['weight'] as int,
      stats: stats,
      abilities: abilities,
      moves : moves,
    );
  }
}