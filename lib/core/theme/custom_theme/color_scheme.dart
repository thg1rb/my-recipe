import 'package:flutter/material.dart';

class CustomColorScheme {
  // Color Variables
  static final Color whiteColor = Colors.white;
  static final Color grayColor = Color(0xFFF7F7F7);
  static final Color yellowColor = Color(0xFFF8D748);
  static final Color redColor = Color(0xFFF23F3F);
  static final Color blackColor = Color(0xFF0E121F);
  static final Color grayBlackColor = Color(0xFF141A2B);

  // Light Color Scheme
  static ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: yellowColor,
    onPrimary: whiteColor,
    secondary: yellowColor,
    onSecondary: whiteColor,
    error: redColor,
    onError: whiteColor,
    surface: grayColor,
    onSurface: blackColor,
  );

  // Dark Color Scheme
    static ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: yellowColor,
    onPrimary: blackColor,
    secondary: yellowColor,
    onSecondary: whiteColor,
    error: redColor,
    onError: blackColor,
    surface: grayBlackColor,
    onSurface: whiteColor,
  );
}
