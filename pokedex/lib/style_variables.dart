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
      color: Colors.grey[700]
  );
}

TextStyle softerTextStyle() {
  return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Colors.grey[600]
  );
}

TextStyle inactiveFilterTextStyle() {
  return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.grey[600],
  );
}

TextStyle activeFilterTextStyle() {
  return const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w800,
      color: Colors.white,
      letterSpacing: 1.5
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

TextStyle baseTextStyleButColorType(Color color) {
  return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: color
  );
}

TextStyle headingTextStyleButColorType(Color color) {
  return TextStyle(
    color: color,
    fontSize: 22,
    fontWeight: FontWeight.w700,
  );
}
