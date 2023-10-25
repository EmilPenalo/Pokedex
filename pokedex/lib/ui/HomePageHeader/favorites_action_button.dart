import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../pages/capture_pokemon_list.dart';

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
  Navigator.of(context)
  .push(
    MaterialPageRoute(
      builder: (context) => CapturePokemonList()
    )
  );
}