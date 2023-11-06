import 'package:pokedex/models/pokemon/pokemon_stat.dart';

class Stats {
  final int baseStat;
  final Stat stat;

  const Stats({
    required this.baseStat,
    required this.stat
  });

  factory Stats.fromJson(Map<String, dynamic> json) {
    Stat stat = Stat.fromJson(json['stat'] as Map<String, dynamic>);

    return Stats(
        baseStat: json['base_stat'] as int,
        stat: stat
    );
  }
}