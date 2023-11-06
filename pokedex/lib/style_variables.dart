import 'package:flutter/material.dart';
import 'package:pokedex/ui/Pokemon/pokemon_types.dart';

import 'helpers/text_helper.dart';

Color primaryColor() {
  return const Color.fromRGBO(100, 147, 235, 1);
}

TextStyle baseTextStyle() {
  return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Colors.grey[800]
  );
}

TextStyle subtitleTextStyle() {
  return TextStyle(
      color: Colors.grey[500],
      fontWeight:FontWeight.w500,
      fontSize: 13
  );
}

TextStyle headingTextStyle(String type) {
  return TextStyle(
    color: getPokemonTypeColor(capitalizeFirstLetter(type)),
    fontSize: 22,
    fontWeight: FontWeight.w700,
  );
}