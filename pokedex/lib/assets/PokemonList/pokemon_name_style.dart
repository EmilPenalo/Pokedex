import 'package:flutter/material.dart';

FittedBox pokemonNameWidget(String name) {
  return FittedBox(
    fit: BoxFit.scaleDown,
    child: Text(
      name,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.grey[800]),
    ),
  );
}