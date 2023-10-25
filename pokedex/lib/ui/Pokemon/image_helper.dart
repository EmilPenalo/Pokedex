import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pokedex/style_variables.dart';

Widget pokemonImage(String url) {
  return SizedBox(
    height: 130,
    width: 170,
    child: Transform.translate(
      offset: const Offset(0, 10),
      child: loadImage(url),
    ),
  );
}

CachedNetworkImage loadImage(String url) {
  return CachedNetworkImage(
    imageUrl: url,
    placeholder: (context, url) => loadingCircle(),
    errorWidget: (context, url, error) => errorWidget(context, url, error),
    fit: BoxFit.contain,
    alignment: Alignment.bottomCenter,
  );
}

Widget errorWidget(context, url, error) {
  print("Error loading image: $error");
  return Icon(Icons.cancel_rounded, color: Colors.grey.shade500, size: 35);
}


Widget loadingCircle() {
  return Center(
    child: SizedBox(
      height: 45,
      width: 45,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(primaryColor()),
      ),
    ),
  );
}