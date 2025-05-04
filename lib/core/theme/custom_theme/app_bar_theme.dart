import 'package:flutter/material.dart';
import 'package:my_recipe/core/theme/custom_theme/color_scheme.dart';
import 'package:my_recipe/core/theme/custom_theme/text_theme.dart';

class CustomAppBarTheme {
  // Light Theme
  static final AppBarTheme lightAppBarTheme = AppBarTheme(
    centerTitle: true,
    titleTextStyle: CustomTextTheme.textTheme.headlineMedium?.copyWith(
      color: CustomColorScheme.whiteColor,
    ),
    backgroundColor: CustomColorScheme.yellowColor,
  );

  // Dark Theme
  static final AppBarTheme darkAppBarTheme = AppBarTheme(
    centerTitle: true,
     titleTextStyle: CustomTextTheme.textTheme.headlineMedium?.copyWith(
      color: CustomColorScheme.blackColor,
    ),
    backgroundColor: CustomColorScheme.yellowColor,
  );
}
