import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pokedex/style_variables.dart';

import '../../pages/capture_pokemon_list.dart';
import '../../pages/transitions/routes.dart';

IconButton favoritesActionButton(BuildContext context) {
  return IconButton(
      icon: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 22,
        child: Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 1.5,
            ),
          ),
          child: SvgPicture.asset(
            'lib/resources/pokeball_icon.svg',
            width: 24,
            height: 24,
          ),
        ),
      ),

      onPressed: () => handleFavoriteButtonClick(context),
  );
}

void handleFavoriteButtonClick(BuildContext context) {
  Navigator.of(context).push(
      createSlideRoute(const CapturePokemonList())
  );
}

Widget searchBar(Function(String) onSubmitted) {
  return Container(
    padding: const EdgeInsets.fromLTRB(8, 0, 8, 2),
    height: 45,
    child: Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(99)),
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 0, 5, 0),
        child: TextField(
          style: baseTextStyle(),
          decoration: InputDecoration(
            suffixIcon: Icon(Icons.search_rounded, color: Colors.grey[400]),
            hintText: 'Search',
            hintStyle: TextStyle(color: Colors.grey[500]),
            border: InputBorder.none,
          ),
          onSubmitted: (value) {
            onSubmitted(value);
          },
        ),
      ),
    ),
  );
}