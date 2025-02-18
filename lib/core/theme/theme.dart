import 'package:flutter/material.dart';
import 'package:my_recipe/core/theme/custom_theme/color_scheme.dart';
import 'package:my_recipe/core/theme/custom_theme/text_theme.dart';

class CustomTheme {
  // Light Theme
  static ThemeData lightTheme = ThemeData(
    textTheme: CustomTextTheme.textTheme,
    colorScheme: CustomColorScheme.lightColorScheme,
  );

  // Dark Theme
 static ThemeData darkTheme = ThemeData(
    textTheme: CustomTextTheme.textTheme,
    colorScheme: CustomColorScheme.darkColorScheme,
 );
}