import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Paleta "terminal" — negro puro + rojo neón.
/// Todos los colores viven aquí para que sea fácil ajustarlos después.
class AppColors {
  AppColors._();

  static const bg = Color(0xFF000000);
  static const surface = Color(0xFF000000);
  static const surfaceRaised = Color(0xFF000000);
  static const red = Color(0xFFFF2B2B);
  static const redSoft = Color(0xFFFF5C5C);
  static const redDim = Color(0xFF5C1010);
  static const line = Color(0xFF2A0A0A);
  static const textDim = Color(0xFF8A8A8A);
  static const white = Color(0xFFF2F2F2);
}

class AppTheme {
  AppTheme._();

  static ThemeData get dark {
    final base = ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.bg,
      colorScheme: const ColorScheme.dark(
        surface: AppColors.surface,
        primary: AppColors.red,
        onPrimary: Colors.black,
        secondary: AppColors.redSoft,
        onSurface: AppColors.red,
        onSurfaceVariant: AppColors.redSoft,
        outline: AppColors.line,
        error: AppColors.red,
      ),
    );

    // google_fonts descarga la fuente una sola vez y la cachea en disco;
    // si por algún motivo no hay red la primera vez, cae de forma segura
    // a la fuente del sistema en vez de tronar la app.
    final textTheme = GoogleFonts.jetBrainsMonoTextTheme(base.textTheme).copyWith(
      headlineSmall: GoogleFonts.jetBrainsMono(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.5,
        color: AppColors.red,
      ),
      titleMedium: GoogleFonts.jetBrainsMono(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
        color: AppColors.red,
      ),
      bodyMedium: GoogleFonts.jetBrainsMono(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.red,
      ),
      bodySmall: GoogleFonts.jetBrainsMono(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: AppColors.redSoft,
      ),
      labelLarge: GoogleFonts.jetBrainsMono(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 2,
        color: AppColors.red,
      ),
    );

    return base.copyWith(
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.bg,
        foregroundColor: AppColors.red,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.jetBrainsMono(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: 2,
          color: AppColors.red,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.black,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
          side: const BorderSide(color: AppColors.red, width: 1),
        ),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.red, thickness: 1),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: AppColors.red,
          elevation: 0,
          side: const BorderSide(color: AppColors.red, width: 1),
          textStyle: GoogleFonts.jetBrainsMono(
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
            fontSize: 12,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.red,
          side: const BorderSide(color: AppColors.red, width: 1),
          textStyle: GoogleFonts.jetBrainsMono(
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
            fontSize: 12,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
        ),
      ),
      iconTheme: const IconThemeData(color: AppColors.red),
      listTileTheme: const ListTileThemeData(
        iconColor: AppColors.red,
        textColor: AppColors.red,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.black,
        side: const BorderSide(color: AppColors.red),
        labelStyle: GoogleFonts.jetBrainsMono(
            fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.red),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.red,
        linearTrackColor: AppColors.redDim,
      ),
    );
  }
}