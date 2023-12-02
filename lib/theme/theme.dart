import 'package:flutter/material.dart';

final theme = ThemeData(
  colorScheme: const ColorScheme(
    primary: Color(0xFFFFB800),
    secondary: Color(0xFF453200),
    surface: Color(0xFFFFFFFF),
    background: Color(0xFFFFFFFF),
    error: Color(0xFFC00000),
    onPrimary: Color(0xF0ECE1),
    onSecondary: Color(0xFFFFFFFF),
    onSurface: Color(0xFF171000),
    onBackground: Color(0xFF171000),
    onError: Color(0xFFFFFFFF),
    brightness: Brightness.light,

  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
        fontFamily: 'Inter', fontSize: 24, fontWeight: FontWeight.bold),
    displayMedium: TextStyle(
        fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.bold),
    displaySmall: TextStyle(
        fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w600),
    headlineMedium: TextStyle(
        fontFamily: 'Inter', fontSize: 8, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(
        fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.normal),
    bodySmall: TextStyle(
        fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.normal),
  ),
  useMaterial3: false,
);
