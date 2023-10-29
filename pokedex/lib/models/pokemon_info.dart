import 'package:pokedex/models/pokemon_sprites.dart';
import 'package:pokedex/models/pokemon_types.dart';

class PokemonInfo {
  final int id;
  final Sprites sprites;
  final List<Types> types;
  final int weight;

  const PokemonInfo({
    required this.id,
    required this.sprites,
    required this.types,
    required this.weight,
  });

  factory PokemonInfo.fromJson(Map<String, dynamic> json) {
    Sprites sprites = Sprites.fromJson(json['sprites'] as Map<String, dynamic>);

    var typesList = json['types'] as List;
    List<Types> types = typesList.map((entry) => Types.fromJson(entry)).toList();

    return PokemonInfo(
        id: json['id'] as int,
        sprites: sprites,
        weight: json['weight'] as int,
        types: types
    );
  }
}