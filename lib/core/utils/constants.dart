import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Health & Fitness Color Palette
  static const Color primaryColor = Color(0xFF6366F1); // Indigo
  static const Color secondaryColor = Color(0xFF06B6D4); // Cyan
  static const Color accentColor = Color(0xFFF43F5E); // Rose (for progress/alerts)
  static const Color backgroundColor = Color(0xFF0F172A); // Slate 900
  static const Color surfaceColor = Color(0xFF1E293B); // Slate 800
  static const Color errorColor = Color(0xFFEF4444);
  static const Color textColor = Colors.white;

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF818CF8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFF06B6D4), Color(0xFF22D3EE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient getBackgroundGradient(bool isDark) {
    if (isDark) {
      return const LinearGradient(
        colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else {
      return const LinearGradient(
        colors: [Color(0xFFF8FAFC), Color(0xFFE2E8F0)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }
  }

  static const Color lightBackgroundColor = Color(0xFFF8FAFC);
  static const Color lightSurfaceColor = Colors.white;
  static const Color lightTextColor = Color(0xFF1E293B);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor,
        error: errorColor,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: backgroundColor,
      textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme).copyWith(
        bodyLarge: GoogleFonts.outfit(color: textColor.withValues(alpha: 0.9)),
        bodyMedium: GoogleFonts.outfit(color: textColor.withValues(alpha: 0.8)),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        titleTextStyle: GoogleFonts.outfit(
          color: textColor,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: textColor),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.all(18),
        labelStyle: const TextStyle(color: Colors.white70),
        hintStyle: const TextStyle(color: Colors.white38),
      ),
      cardTheme: const CardThemeData(
        color: surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) => 
          states.contains(WidgetState.selected) ? Colors.white : Colors.white60),
        trackColor: WidgetStateProperty.resolveWith((states) => 
          states.contains(WidgetState.selected) ? primaryColor : Colors.white10),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
        surface: lightSurfaceColor,
        error: errorColor,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: lightBackgroundColor,
      textTheme: GoogleFonts.outfitTextTheme(ThemeData.light().textTheme).copyWith(
        bodyLarge: GoogleFonts.outfit(color: lightTextColor),
        bodyMedium: GoogleFonts.outfit(color: lightTextColor.withValues(alpha: 0.8)),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        titleTextStyle: GoogleFonts.outfit(
          color: lightTextColor,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: lightTextColor),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: primaryColor.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.all(18),
        labelStyle: const TextStyle(color: Colors.grey),
        hintStyle: const TextStyle(color: Colors.grey),
      ),
      cardTheme: const CardThemeData(
        color: Colors.white,
        elevation: 2,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) => 
          states.contains(WidgetState.selected) ? Colors.white : Colors.grey),
        trackColor: WidgetStateProperty.resolveWith((states) => 
          states.contains(WidgetState.selected) ? primaryColor : Colors.grey[300]),
      ),
    );
  }
}
