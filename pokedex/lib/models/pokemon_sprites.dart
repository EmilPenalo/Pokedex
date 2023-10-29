import 'package:pokedex/models/pokemon_other.dart';

class Sprites {
  final Other other;

  const Sprites({
    required this.other,
  });

  factory Sprites.fromJson(Map<String, dynamic> json) {
    Other other = Other.fromJson(json['other'] as Map<String, dynamic>);

    return Sprites(
        other: other
    );
  }
}