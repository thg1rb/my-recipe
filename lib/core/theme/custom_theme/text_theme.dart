import 'package:flutter/material.dart';

class CustomTextTheme {
  static TextTheme textTheme = TextTheme(
    headlineLarge: TextStyle(fontWeight: FontWeight.w700, fontSize: 30),  // Bold
    headlineMedium: TextStyle(fontWeight: FontWeight.w500, fontSize: 24), // Medium
    bodyLarge: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),      // Regular, Normal
    bodyMedium: TextStyle(fontWeight: FontWeight.w300, fontSize: 16),     // Light
    bodySmall: TextStyle(fontWeight: FontWeight.w100, fontSize: 14),      // Thin
  ).apply(fontFamily: "Kanit");
}
