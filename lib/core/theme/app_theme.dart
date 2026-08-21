import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Paleta oscura: negro como base (nunca blanco), rojo reservado para
/// acción primaria y marca, un color de categoría por módulo usado SOLO
/// como contorno/texto (nunca como fondo de superficie). Ver [AccentScope].
class AppColors {
  AppColors._();

  // ─── Base / neutrales — negro, nunca blanco ──────────────────
  static const bg = Color(0xFF000000);
  static const surface = Color(0xFF0C0C0C);
  static const surfaceAlt = Color(0xFF161616);
  static const border = Color(0xFF222222);
  static const borderStrong = Color(0xFF333333);
  static const textPrimary = Color(0xFFF2F2F2);
  static const textSecondary = Color(0xFF8F8F8F);
  static const textTertiary = Color(0xFF5C5C5C);

  // ─── Marca / acción — nunca usado como color de categoría ───
  static const red = Color(0xFFFF4D5E);
  static const redPressed = Color(0xFFD53548);
  static const redTint = Color(0xFF2A1416);

  static const success = Color(0xFF2ED8A7);

  // ─── Color por categoría — SOLO contorno/texto, nunca relleno ─
  static const categoryOrganization = Color(0xFF22B8C4); // azul petróleo
  static const categoryConversion = Color(0xFF3DCB6E); // verde
  static const categoryEditing = Color(0xFFF2A93C); // ámbar
  static const categorySecurity = Color(0xFF9B7DFF); // morado
  static const categoryExtras = Color(0xFF8FA3C7); // gris azulado
}

/// Expone el color de categoría vigente al subárbol, para que los
/// widgets compartidos (file picker, sliders, selección de páginas)
/// hereden el acento del módulo actual sin recibirlo por parámetro.
class AccentScope extends InheritedWidget {
  final Color color;
  const AccentScope({super.key, required this.color, required super.child});

  static Color of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AccentScope>()?.color ??
      AppColors.red;

  @override
  bool updateShouldNotify(AccentScope oldWidget) => color != oldWidget.color;
}

class AppTheme {
  AppTheme._();

  /// Decoración estándar de tarjeta: leve degradado + sombra para separar
  /// capas del fondo negro, en vez de un relleno plano — el mismo
  /// tratamiento en FileTile, ResultCard, filas de categoría, Ajustes y
  /// Recientes, para que toda la app se sienta como una sola superficie.
  static BoxDecoration card({
    double radius = 14,
    Color? borderColor,
    double borderWidth = 1,
  }) {
    return BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF121212), Color(0xFF0A0A0A)],
      ),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: borderColor ?? AppColors.border, width: borderWidth),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.45),
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  static ThemeData get theme {
    final base = ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.bg,
      colorScheme: const ColorScheme.dark(
        surface: AppColors.surface,
        primary: AppColors.red,
        onPrimary: Colors.white,
        secondary: AppColors.red,
        onSurface: AppColors.textPrimary,
        onSurfaceVariant: AppColors.textSecondary,
        outline: AppColors.border,
        error: AppColors.red,
      ),
      dividerColor: AppColors.border,
    );

    final textTheme = GoogleFonts.interTextTheme(base.textTheme).copyWith(
      headlineSmall: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
        color: AppColors.textPrimary,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        height: 1.35,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        height: 1.3,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    );

    return base.copyWith(
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
      cardTheme: const CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          side: BorderSide(color: AppColors.border),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          animationDuration: const Duration(milliseconds: 90),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return AppColors.surfaceAlt;
            }
            if (states.contains(WidgetState.pressed)) {
              return AppColors.redPressed;
            }
            return AppColors.red;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) =>
              states.contains(WidgetState.disabled)
                  ? AppColors.textTertiary
                  : Colors.white),
          elevation: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.disabled) ? 0 : 8),
          shadowColor: const WidgetStatePropertyAll(AppColors.red),
          textStyle: WidgetStatePropertyAll(GoogleFonts.inter(
              fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 0)),
          shape: const WidgetStatePropertyAll(RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)))),
          padding: const WidgetStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 20, vertical: 16)),
          minimumSize: const WidgetStatePropertyAll(Size(double.infinity, 52)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.borderStrong),
          textStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.red,
          textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceAlt,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.red, width: 1.5),
        ),
        labelStyle: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary),
        hintStyle: GoogleFonts.inter(fontSize: 14, color: AppColors.textTertiary),
      ),
      iconTheme: const IconThemeData(color: AppColors.textPrimary),
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.red,
        inactiveTrackColor: AppColors.surfaceAlt,
        thumbColor: AppColors.red,
        overlayColor: AppColors.red.withValues(alpha: 0.18),
        valueIndicatorColor: AppColors.textPrimary,
        valueIndicatorTextStyle: GoogleFonts.inter(color: AppColors.bg, fontWeight: FontWeight.w600),
        trackHeight: 3,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: const WidgetStatePropertyAll(Colors.white),
        trackColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected)
                ? AppColors.red
                : AppColors.borderStrong),
        trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.red,
        linearTrackColor: AppColors.surfaceAlt,
        circularTrackColor: AppColors.surfaceAlt,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceAlt,
        shape: StadiumBorder(side: BorderSide(color: AppColors.border)),
        side: const BorderSide(color: AppColors.border),
        labelStyle: GoogleFonts.inter(
            fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
      ),
    );
  }
}
