import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF1F2937);
  static const Color accent = Color(0xFF7C3AED);

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF0B0F12),
    colorScheme: const ColorScheme.dark(primary: accent, secondary: accent),
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.transparent,
    ),
    cardTheme: CardThemeData(
      // ✅ use CardThemeData
      color: const Color(0xFF111316),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF0E1112),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
    ),
  );
}
