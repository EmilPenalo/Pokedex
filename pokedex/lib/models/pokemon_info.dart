import 'package:pokedex/models/pokemon_sprites.dart';
import 'package:pokedex/models/pokemon_types.dart';

class PokemonInfo {
  final Sprites sprites;
  final List<Types> types;

  const PokemonInfo({
    required this.sprites,
    required this.types,
  });

  factory PokemonInfo.fromJson(Map<String, dynamic> json) {
    Sprites sprites = Sprites.fromJson(json['sprites'] as Map<String, dynamic>);

    var typesList = json['types'] as List;
    List<Types> types = typesList.map((entry) => Types.fromJson(entry)).toList();

    return PokemonInfo(
      sprites: sprites,
      types: types,
    );
  }
}