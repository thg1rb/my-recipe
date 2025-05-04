import 'package:flutter/material.dart';
import 'package:my_recipe/core/theme/custom_theme/color_scheme.dart';
import 'package:my_recipe/core/theme/custom_theme/text_theme.dart';

class CustomElevatedButtonTheme {
  // Light Theme
  static final ElevatedButtonThemeData lightElevatedButtonTheme =
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: CustomColorScheme.blackColor,
          foregroundColor: CustomColorScheme.whiteColor,
          textStyle: CustomTextTheme.textTheme.bodyLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

  // Dark Theme
  static final ElevatedButtonThemeData darkElevatedButtonTheme =
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: CustomColorScheme.whiteColor,
          foregroundColor: CustomColorScheme.blackColor,
          textStyle: CustomTextTheme.textTheme.bodyLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
}