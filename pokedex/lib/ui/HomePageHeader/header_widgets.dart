import 'package:flutter/material.dart';

import '../../style_variables.dart';
import 'header_actions.dart';

Row headerBottomBarWidget(BuildContext context) {
  return Row(
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.end,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      favoritesActionButton(context)
    ],
  );
}

Widget expandedHeaderWidget(BuildContext context, Function(String) searchQuery) {

  Color bgColor = primaryColor();
  double imageOpacity = 0.4;
  String imageSource = 'lib/resources/pokeball.png';

  TextStyle titleStyle = const TextStyle(
    color: Colors.white,
    fontSize: 50.0,
    fontWeight: FontWeight.w900,
    letterSpacing: 10.0,
  );

  return Stack(
    children: [
      OverflowBox(
          alignment: Alignment.center,
          maxWidth: 420,
          maxHeight: 300,
          child: Container(
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
          )
      ),

      Positioned(
        bottom: 0,
        right: 0,
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(5),
          child: Row(
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: searchBar(searchQuery),
              ),
              favoritesActionButton(context),
            ],
          ),
        ),
      ),

    ],
  );
}

Widget headerSmall(BuildContext context, Function(String) searchQuery) {
  return Column(
    children: [
      AppBar(
        elevation: 0,
        backgroundColor: primaryColor(),
        title: const Text("POKEDEX"),
        centerTitle: true,
        actions: [
          favoritesActionButton(context)
        ],
      ),

      searchBar(searchQuery)
    ],
  );
}

Widget headerWidget(BuildContext context, Function(String) searchQuery) {
  return LayoutBuilder(
    builder: (context, constraints) {
      double top = constraints.biggest.height;
      bool isExpanded = top > 145;

      return AnimatedCrossFade(
        duration: const Duration(milliseconds: 500),
        firstCurve: Curves.easeInOutCubic,
        secondCurve: Curves.easeInOutCubic,
        sizeCurve: Curves.easeInOutCubic,
        crossFadeState: isExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        firstChild: isExpanded ? expandedHeaderWidget(context, searchQuery) : const SizedBox(height: 0,),
        secondChild: headerSmall(context, searchQuery),
        alignment: Alignment.topCenter,
      );
    },
  );
}


