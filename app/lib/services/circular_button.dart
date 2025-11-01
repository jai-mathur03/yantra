
import 'package:flutter/material.dart';

TextButton CircularButton(Function() onPressed, String text) {
  return TextButton(
    style: TextButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: Colors.orange,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 3,
      shadowColor: Colors.orange.withOpacity(0.5),
    ),
    onPressed: onPressed,
    child:
        Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
  );
}
