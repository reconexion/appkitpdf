import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Paleta oscura con acentos vivos: negro casi puro como base (nunca
/// blanco), rojo reservado para acción primaria y marca, un color
/// primario vivo por categoría usado como RELLENO PLANO de sus tarjetas
/// (nunca solo contorno) — ver [AppTheme.colorCard]. Insignias de ícono
/// son siempre círculos negros ([AppColors.badge]) con ícono blanco,
/// independientes del color de la tarjeta que las contiene, así el
/// contraste queda garantizado sin importar qué tan claro sea el acento.
class AppColors {
  AppColors._();

  // ─── Base / neutrales — negro, nunca blanco ──────────────────
  static const bg = Color(0xFF0A0A0E);
  static const surface = Color(0xFF16161D);
  static const surfaceAlt = Color(0xFF1D1D26);
  static const border = Color(0xFF2C2C36);
  static const borderStrong = Color(0xFF3E3E4A);
  static const textPrimary = Color(0xFFF2F1F5);
  static const textSecondary = Color(0xFFA3A2AD);
  static const textTertiary = Color(0xFF6B6A75);

  // ─── Marca / acción ───────────────────────────────────────────
  static const red = Color(0xFFFF3B54);
  static const redPressed = Color(0xFFE23F50);
  static const success = Color(0xFF1FE08A);

  // ─── Insignia + texto sobre tarjetas de color plano ───────────
  static const badge = Color(0xFF14120E);
  static const cardText = Color(0xFF14120E);

  // ─── Color primario por categoría — relleno plano de tarjeta ──
  static const categoryOrganization = Color(0xFF2E6BFF); // azul
  static const categoryConversion = Color(0xFF17D97A); // verde
  static const categoryEditing = Color(0xFFFFC22E); // ámbar
  static const categorySecurity = Color(0xFF9B4DFF); // morado
  static const categoryExtras = Color(0xFFFF7A29); // naranja
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

/// Insignia circular negra con ícono blanco — el mismo lenguaje visual
/// en cada tarjeta de color de la app (categorías, herramientas,
/// archivo seleccionado, resultado, recientes).
class BlackBadge extends StatelessWidget {
  final IconData icon;
  final double size;
  final double iconSize;
  const BlackBadge({super.key, required this.icon, this.size = 34, this.iconSize = 17});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: const BoxDecoration(color: AppColors.badge, shape: BoxShape.circle),
      child: Icon(icon, size: iconSize, color: Colors.white),
    );
  }
}

class AppTheme {
  AppTheme._();

  /// Aclara (`percent` > 0) u oscurece (`percent` < 0) un color mezclándolo
  /// con blanco/negro — usado para dar variantes de un mismo acento sin
  /// inventar colores nuevos (p. ej. las tarjetas de una lista de
  /// herramientas dentro de una sola categoría).
  static Color shade(Color color, double percent) {
    final delta = (2.55 * percent).round();
    int ch(int v) => (v + delta).clamp(0, 255);
    return Color.fromARGB(
      255,
      ch((color.r * 255).round()),
      ch((color.g * 255).round()),
      ch((color.b * 255).round()),
    );
  }

  /// Decoración de "tarjeta de color": relleno plano del acento con un
  /// leve brillo superior (toque Frutiger Aero), borde negro y un halo
  /// exterior en el mismo color de la tarjeta — el lenguaje visual de
  /// categorías, herramientas, archivo seleccionado, resultado y
  /// recientes en toda la app.
  static BoxDecoration colorCard(Color color, {double radius = 18}) {
    final glossed = Color.alphaBlend(Colors.white.withValues(alpha: 0.32), color);
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [glossed, color],
        stops: const [0, 0.55],
      ),
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        const BoxShadow(color: AppColors.badge, blurRadius: 0, spreadRadius: 2),
        BoxShadow(color: color.withValues(alpha: 0.55), blurRadius: 0, spreadRadius: 4.5),
        BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 8)),
      ],
    );
  }

  /// Decoración estándar de tarjeta neutra (fondos oscuros: formularios,
  /// listas de Ajustes, aviso de privacidad) — sin relleno de color.
  static BoxDecoration card({
    double radius = 16,
    Color? borderColor,
    double borderWidth = 1.5,
  }) {
    return BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: borderColor ?? AppColors.border, width: borderWidth),
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

    final displayFont = GoogleFonts.spaceGrotesk;
    final textTheme = GoogleFonts.interTextTheme(base.textTheme).copyWith(
      headlineSmall: displayFont(
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
        backgroundColor: AppColors.bg,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: displayFont(
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
          borderRadius: BorderRadius.all(Radius.circular(16)),
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
          elevation: const WidgetStatePropertyAll(0),
          textStyle: WidgetStatePropertyAll(GoogleFonts.inter(
              fontSize: 15, fontWeight: FontWeight.w700, letterSpacing: 0)),
          shape: const WidgetStatePropertyAll(StadiumBorder()),
          padding: const WidgetStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 20, vertical: 17)),
          minimumSize: const WidgetStatePropertyAll(Size(double.infinity, 54)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.borderStrong),
          textStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
          minimumSize: const Size(double.infinity, 54),
          shape: const StadiumBorder(),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.red,
          textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700),
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
        valueIndicatorColor: AppColors.badge,
        valueIndicatorTextStyle: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600),
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
        backgroundColor: AppColors.badge,
        shape: const StadiumBorder(side: BorderSide.none),
        side: BorderSide.none,
        labelStyle: GoogleFonts.inter(
            fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
      ),
    );
  }
}

/// Barra flotante tipo "vidrio esmerilado" — fondo semitransparente con
/// desenfoque real del contenido detrás, borde translúcido y sombra
/// suave. Usada por la navegación inferior; el [Scaffold] que la aloja
/// necesita `extendBody: true` para que el contenido se vea a través.
class GlassPill extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  const GlassPill({super.key, required this.child, this.padding = const EdgeInsets.all(10)});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.45),
                  blurRadius: 30,
                  offset: const Offset(0, 12)),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
