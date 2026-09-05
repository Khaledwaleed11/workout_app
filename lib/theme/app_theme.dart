import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryOrange = Color(0xFFFF6B00);
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkCardColor = Color(0xFF1E293B);

  // Dark Theme (Primary View)
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBackground,
    primaryColor: primaryOrange,
    colorScheme: const ColorScheme.dark(
      primary: primaryOrange,
      surface: darkCardColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: darkBackground,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        letterSpacing: 1.1,
      ),
    ),
    cardTheme: CardThemeData( // 👈 تم التعديل إلى CardThemeData
      color: darkCardColor,
      elevation: 4,
      shadowColor: Colors.black45,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );

  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF8FAFC),
    primaryColor: primaryOrange,
    colorScheme: const ColorScheme.light(
      primary: primaryOrange,
      surface: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF8FAFC),
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.black87),
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
        letterSpacing: 1.1,
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );
}