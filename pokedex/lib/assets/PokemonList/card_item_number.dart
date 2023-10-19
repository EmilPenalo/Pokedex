import 'package:flutter/material.dart';

Positioned cardItemNumber(String text) {
  var style = TextStyle(color: Colors.grey[600], fontWeight:FontWeight.w600, fontSize: 14);
  return Positioned(
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Text(text, style: style,),
      )
  );
}