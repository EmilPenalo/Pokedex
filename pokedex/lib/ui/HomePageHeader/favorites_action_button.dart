import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

IconButton favoritesActionButton() {
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

      onPressed: handleFavoriteButtonClick
  );
}

void handleFavoriteButtonClick() {
  print("Clicked Favorites");
}