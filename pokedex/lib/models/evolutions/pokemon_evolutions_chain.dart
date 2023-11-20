import 'package:pokedex/models/species/pokemon_species.dart';

class Chain {
  final List<Chain> evolvesTo;
  final Species species;

  Chain({
    required this.evolvesTo,
    required this.species,
  });

  factory Chain.fromJson(Map<String, dynamic> json) {
    var evolvesToList = json['evolves_to'] as List;
    List<Chain> evolvesTo = evolvesToList.map((entry) => Chain.fromJson(entry)).toList();

    Species species = Species.fromJson(json['species'] as Map<String, dynamic>);

    return Chain(
      evolvesTo: evolvesTo,
      species: species,
    );
  }
}
