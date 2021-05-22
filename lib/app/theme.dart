import 'package:flutter/material.dart';

import 'colors.dart';

final lightThemeData = (BuildContext context) => ThemeData(
    fontFamily: 'Quicksand',
    primaryColor: LightColorPalette.primaryColor,
    primarySwatch: Colors.teal,
    errorColor: LightColorPalette.errorColor,
    snackBarTheme: SnackBarThemeData(
      backgroundColor: LightColorPalette.surfaceColor,
      actionTextColor: LightColorPalette.textPrimaryColor,
    ),
    iconTheme: IconThemeData(color: LightColorPalette.primaryColor),
    textTheme: Theme.of(context).textTheme.apply(
        bodyColor: LightColorPalette.textPrimaryColor, fontFamily: 'Quicksand'),
    scaffoldBackgroundColor: LightColorPalette.backgroundColor);

final darkThemeData = (BuildContext context) => ThemeData(
    fontFamily: 'Quicksand',
    primaryColor: DarkColorPalette.primaryColor,
    primarySwatch: Colors.teal,
    errorColor: DarkColorPalette.errorColor,
    snackBarTheme: SnackBarThemeData(
      backgroundColor: DarkColorPalette.surfaceColor,
      actionTextColor: DarkColorPalette.textPrimaryColor,
    ),
    iconTheme: IconThemeData(color: DarkColorPalette.primaryColor),
    textTheme: Theme.of(context).textTheme.apply(
        bodyColor: DarkColorPalette.textPrimaryColor, fontFamily: 'Quicksand'),
    scaffoldBackgroundColor: DarkColorPalette.backgroundColor);
