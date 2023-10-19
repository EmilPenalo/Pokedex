import 'package:flutter/material.dart';

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