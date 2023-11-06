import 'package:pokedex/models/pokemon/pokemon_ability.dart';

class Abilities {
  final Ability ability;
  final bool isHidden;

  const Abilities({
    required this.ability,
    required this.isHidden,
  });

  factory Abilities.fromJson(Map<String, dynamic> json) {
    Ability ability = Ability.fromJson(json['ability'] as Map<String, dynamic>);

    return Abilities(
      ability: ability,
      isHidden: json['is_hidden'] as bool,
    );
  }
}