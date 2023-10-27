import 'package:pokedex/models/pokemon_types.dart';

class PokemonInfo {
  final int id;
  final List<Types> types;
  final int weight;

  const PokemonInfo({
    required this.id,
    required this.types,
    required this.weight,
  });

  factory PokemonInfo.fromJson(Map<String, dynamic> json) {
    var typesList = json['types'] as List;
    List<Types> types = typesList.map((entry) => Types.fromJson(entry)).toList();

    return PokemonInfo(
        id: json['id'] as int,
        weight: json['weight'] as int,
        types: types
    );
  }
}