import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pokedex/style_variables.dart';

Widget pokemonImage(String? url) {
  return Transform.translate(
      offset: const Offset(0, 5),
      child: url != null ? loadImage(url) :
        Container(
          alignment: Alignment.center,
          width: 80,
          child: SvgPicture.asset(
            'lib/resources/pokeball_icon.svg',
            color: primaryColor(),
            fit: BoxFit.contain,
          ),
        )
  );
}

CachedNetworkImage loadImage(String url) {
  return CachedNetworkImage(
    imageUrl: url,
    imageBuilder: (context, imageProvider) => Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: imageProvider,
          fit: BoxFit.contain,
          alignment: Alignment.bottomCenter,
          filterQuality: FilterQuality.low,
        )
      ),
    ),
    placeholder: (context, url) => loadingCircle(),
    errorWidget: (context, url, error) => errorWidget(context, url, error),
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