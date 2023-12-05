import 'package:flutter/material.dart';

Row pokemonTypes(String type1, String type2) {
  const height = 20.0;
  const spacing = 15.0;
  const padding = EdgeInsets.symmetric(horizontal: 5, vertical: 0);

  var textStyle = const TextStyle(
      fontSize: 13,
      color: Colors.white,
      fontWeight: FontWeight.w900
  );

  var colorType1 = getPokemonTypeColor(type1);
  var colorType2 = type2.isNotEmpty ? getPokemonTypeColor(type2) : null;

  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      // Type 1
      Expanded(
        child: SizedBox(
          height: height,
          child: Container(
            alignment: Alignment.center,
            padding: padding,
            decoration: BoxDecoration(
              color: colorType1,
              borderRadius: BorderRadius.circular(20),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                type1,
                style: textStyle,
              ),
            ),
          ),
        ),
      ),
      if (type2.isNotEmpty) ...[
        const SizedBox(width: spacing),
        // Type 2
        Expanded(
          child: SizedBox(
            height: height,
            child: Container(
              alignment: Alignment.center,
              padding: padding,
              decoration: BoxDecoration(
                color: colorType2,
                borderRadius: BorderRadius.circular(20),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  type2,
                  style: textStyle,
                ),
              ),
            ),
          ),
        ),
      ],
    ],
  );
}

Color getPokemonTypeColor(String type) {
  Color color;

  switch (type) {
    case "Bug":
      color = const Color.fromRGBO(167, 183, 35, 1);
      break;
    case "Dark":
      color = const Color.fromRGBO(135, 104, 93, 1);
      break;
    case "Dragon":
      color = const Color.fromRGBO(152, 112, 253, 1);
      break;
    case "Electric":
      color = const Color.fromRGBO(225, 187, 43, 1);
      break;
    case "Fairy":
      color = const Color.fromRGBO(219, 153, 166, 1);
      break;
    case "Fighting":
      color = const Color.fromRGBO(201, 50, 72, 1);
      break;
    case "Fire":
      color = const Color.fromRGBO(227, 117, 47, 1);
      break;
    case "Flying":
      color = const Color.fromRGBO(168, 145, 236, 1);
      break;
    case "Ghost":
      color = const Color.fromRGBO(112, 85, 155, 1);
      break;
    case "Normal":
      color = const Color.fromRGBO(170, 166, 127, 1);
      break;
    case "Grass":
      color = const Color.fromRGBO(116, 203, 72, 1);
      break;
    case "Ground":
      color = const Color.fromRGBO(203, 178, 102, 1);
      break;
    case "Ice":
      color = const Color.fromRGBO(134, 190, 198, 1);
      break;
    case "Poison":
      color = const Color.fromRGBO(164, 62, 158, 1);
      break;
    case "Psychic":
      color = const Color.fromRGBO(251, 85, 132, 1);
      break;
    case "Rock":
      color = const Color.fromRGBO(182, 158, 49, 1);
      break;
    case "Steel":
      color = const Color.fromRGBO(165, 166, 187, 1);
      break;
    case "Water":
      color = const Color.fromRGBO(100, 147, 235, 1);
      break;
    default:
      color = Colors.grey[500]!;
  }

  return color;
}

List<String> pokemonTypesDictionary = [
  "All types",
  "Bug",
  "Dark",
  "Dragon",
  "Electric",
  "Fairy",
  "Fighting",
  "Fire",
  "Flying",
  "Ghost",
  "Normal",
  "Grass",
  "Ground",
  "Ice",
  "Poison",
  "Psychic",
  "Rock",
  "Steel",
  "Water",
];