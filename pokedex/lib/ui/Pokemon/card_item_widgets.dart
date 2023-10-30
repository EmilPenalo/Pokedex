import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../style_variables.dart';

// Fondo para informacion del pokemon
Positioned cardItemBackground() {
  return Positioned(
    bottom: 0,
    left: 0,
    right: 0,
    child: Container(
      height: 85,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
    ),
  );
}

// Numero del pokemom
Positioned cardItemNumber(String text) {
  return Positioned(
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Text(text, style: subtitleTextStyle(),),
      )
  );
}

// Icono de favorito
Container likedIcon() {
  return Container(
    height: 40,
    width: 40,
    padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),

    decoration: BoxDecoration(
      color: primaryColor(),
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(5),
        bottomLeft: Radius.circular(5),
        bottomRight: Radius.circular(40),
      ),
    ),

    child: Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.fromLTRB(3, 3, 0, 0),
      child: SvgPicture.asset(
        'lib/resources/pokeball_icon.svg',
        width: 18,
        height: 18,
      ),
    ),
  );
}

// Nombre del Pokemon
FittedBox pokemonNameWidget(String name) {
  return FittedBox(
    fit: BoxFit.scaleDown,
    child: Text(
      name,
      style: baseTextStyle()
    ),
  );
}

Widget pokemonCardPlaceHolder() {
  return Card(
      color: Colors.white,
      elevation: 0.8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Stack(
      children: [
        cardItemBackground(),
      ],
    )
  );
}

Widget pokemonCardError() {
  return Card(
      color: Colors.white,
      elevation: 0.8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Stack(
        children: [
          cardItemBackground(),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.cancel_rounded, color: Colors.grey.shade500, size: 35),
                Text("Error al cargar el Pokemon", style: subtitleTextStyle(),)
              ],
            ),
          ),
        ],
      )
  );
}