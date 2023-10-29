import 'package:pokedex/models/pokemon_type.dart';

class Types {
  final int slot;
  final Type type;

  const Types({
    required this.slot,
    required this.type
  });

  factory Types.fromJson(Map<String, dynamic> json) {
    Type type = Type.fromJson(json['type'] as Map<String, dynamic>);

    return Types(
      slot: json['slot'] as int,
      type: type
    );
  }
}