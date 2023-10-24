import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pokedex/style_variables.dart';

Widget pokemonImage(String url) {
  return SizedBox(
    height: 120,
    child: loadImage(url),
  );
}

CachedNetworkImage loadImage(String url) {
  return CachedNetworkImage(
    imageUrl: url,
    placeholder: (context, url) => loadingCircle(),
    errorWidget: (context, url, error) => errorWidget(context, url, error),
    fit: BoxFit.contain,
  );
}

Widget errorWidget(context, url, error) {
  print("Error loading image: $error");
  return Icon(Icons.error, color: Colors.grey.shade700);
}


Widget loadingCircle() {
  return Container(
    padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
    child: CircularProgressIndicator(
      strokeWidth: 2,
      color: primaryColor(),
    )
  );
}