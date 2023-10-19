import 'package:flutter/material.dart';

IconButton favoritesActionButton() {
  return IconButton(
      icon: CircleAvatar(
        backgroundColor: Colors.yellow.shade500,
        radius: 20,
        child: const Icon(Icons.star_sharp, color: Colors.white, size: 22),
      ),
      onPressed: handleFavoriteButtonClick
  );
}

void handleFavoriteButtonClick() {
  print("Clicked Favorites");
}