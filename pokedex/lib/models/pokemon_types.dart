import 'package:pokedex/models/pokemon_type_detail.dart';

class Types {
  final int slot;
  final TypeDetail type;

  const Types({
    required this.slot,
    required this.type
  });

  factory Types.fromJson(Map<String, dynamic> json) {
    TypeDetail type = TypeDetail.fromJson(json['type'] as Map<String, dynamic>);

    return Types(
      slot: json['slot'] as int,
      type: type
    );
  }
}