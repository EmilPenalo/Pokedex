import 'package:flutter/material.dart';

import '../../style_variables.dart';
import 'favorites_action_button.dart';

Row headerBottomBarWidget() {
  return Row(
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.end,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [

      favoritesActionButton()

    ],
  );
}

Widget appHeaderTitle() {
  return const Text("POKEDEX");
}

Widget headerWidget(BuildContext context) {

  Color bgColor = primaryColor();
  double imageOpacity = 0.4;
  String imageSource = 'lib/resources/pokeball.png';

  TextStyle titleStyle = const TextStyle(
    color: Colors.white,
    fontSize: 50.0,
    fontWeight: FontWeight.w900,
    letterSpacing: 10.0,
  );

  return Container(
    color: bgColor,
    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
    child: Stack(
      alignment: Alignment.center,
      children: [

        // Imagen de Pokeball
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 40),
            child:
            Image.asset(
              imageSource,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.contain,
              color: bgColor.withOpacity(imageOpacity),
              colorBlendMode: BlendMode.srcOver,
            ),
          ),
        ),

        // Texto
        Center(
          child: FittedBox(
            alignment: Alignment.center,
            fit: BoxFit.scaleDown,
            child: Text(
              "POKEDEX",
              style: titleStyle,
            ),
          ),
        ),

      ],
    ),
  );
}