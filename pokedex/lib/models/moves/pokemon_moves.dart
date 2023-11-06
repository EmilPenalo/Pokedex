import 'package:pokedex/models/moves/pokemon_move.dart';

class Moves {
  final Move move;

  const Moves({
    required this.move,
  });

  factory Moves.fromJson(Map<String, dynamic> json) {
    Move move = Move.fromJson(json['move'] as Map<String, dynamic>);

    return Moves(
        move: move,
    );
  }
}