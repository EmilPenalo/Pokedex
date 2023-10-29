import 'package:pokedex/models/pokemon.dart';

class Pokedex {
  final int count;
  final String? next;
  final List<Pokemon> results;

  const Pokedex({
      required this.count,
      required this.next,
      required this.results
  });

  factory Pokedex.fromJson(Map<String, dynamic> json) {
    var resultsList = json['results'] as List;
    List<Pokemon> results = resultsList.map((entry) => Pokemon.fromJson(entry)).toList();

    return Pokedex(
        count: json['count'] as int,
        next: json['next'] as String?,
        results: results
    );
  }
}