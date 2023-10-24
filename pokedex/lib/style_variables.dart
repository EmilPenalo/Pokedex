import 'package:flutter/material.dart';

Color primaryColor() {
  return const Color.fromRGBO(100, 147, 235, 1);
}

TextStyle baseTextStyle() {
  return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Colors.grey[800]
  );
}

TextStyle subtitleTextStyle() {
  return TextStyle(
      color: Colors.grey[600],
      fontWeight:FontWeight.w500,
      fontSize: 13
  );
}