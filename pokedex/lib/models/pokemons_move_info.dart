import 'package:pokedex/models/pokemon_move_damage_class.dart';
import 'package:pokedex/models/pokemon_type.dart';

class PokemonMoveInfo {
  final int? accuracy;
  final DamageClass damageClass;
  final String name;
  final int? power;
  final int pp;
  final Type type;

  const PokemonMoveInfo({
    required this.accuracy,
    required this.damageClass,
    required this.name,
    required this.power,
    required this.pp,
    required this.type,
  });

  factory PokemonMoveInfo.fromJson(Map<String, dynamic> json) {
    DamageClass damageClass = DamageClass.fromJson(json['type'] as Map<String, dynamic>);

    Type type = Type.fromJson(json['damage_class'] as Map<String, dynamic>);

    return PokemonMoveInfo(
      accuracy: json['accuracy'] as int?,
      damageClass: damageClass,
      name: json['name'] as String,
      power: json['power'] as int?,
      pp: json['pp'] as int,
      type: type,
    );
  }
}