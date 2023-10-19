import 'package:flutter/material.dart';

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