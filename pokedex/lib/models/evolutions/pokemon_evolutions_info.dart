import 'package:pokedex/models/evolutions/pokemon_evolutions_chain.dart';

class PokemonEvolutionsInfo {
  final Chain chain;

  PokemonEvolutionsInfo({
    required this.chain,
  });

  factory PokemonEvolutionsInfo.fromJson(Map<String, dynamic> json) {
    Chain chain = Chain.fromJson(json['chain'] as Map<String, dynamic>);

    return PokemonEvolutionsInfo(
      chain: chain,
    );
  }
}