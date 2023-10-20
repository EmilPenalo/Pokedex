import 'package:flutter/material.dart';

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
  var style = TextStyle(color: Colors.grey[600], fontWeight:FontWeight.w500, fontSize: 13);
  return Positioned(
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Text(text, style: style,),
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
      color: Colors.yellow[500],
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(5),
        bottomLeft: Radius.circular(5),
        bottomRight: Radius.circular(40),
      ),
    ),
    child: const Align(
      alignment: Alignment.topLeft,
      child: Icon(Icons.star_sharp, color: Colors.white, size: 22),
    ),
  );
}

// Nombre del Pokemon
FittedBox pokemonNameWidget(String name) {
  return FittedBox(
    fit: BoxFit.scaleDown,
    child: Text(
      name,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.grey[800]),
    ),
  );
}