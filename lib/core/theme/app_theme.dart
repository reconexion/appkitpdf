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

  // Un color de acento por funcionalidad — el negro + rojo sigue siendo
  // la identidad general (home, splash), pero dentro de cada sección
  // estos reemplazan al rojo en bordes/íconos/botones para que el
  // usuario distinga de un vistazo en qué módulo está.
  static const accentOrganization = Color(0xFF39FF6A);
  static const accentConversion = Color(0xFF29E7FF);
  static const accentEditing = Color(0xFFFFC93C);
  static const accentSecurity = Color(0xFFFF3CAC);
  static const accentExtras = Color(0xFF7C5CFF);
  static const accentRename = Color(0xFFFF7A29);

  /// Paleta rotativa para las opciones DENTRO de cada módulo (merge,
  /// split, remove... / pdf→img, img→pdf...): cada operación toma un
  /// color distinto de aquí (por índice) para que también se distingan
  /// entre sí, no solo el módulo contenedor.
  static const operationPalette = [
    accentOrganization,
    accentConversion,
    accentEditing,
    accentSecurity,
    accentExtras,
    accentRename,
    Color(0xFF1DE9B6), // teal
    Color(0xFF3DA9FC), // sky
  ];

  static Color operationColor(int index) =>
      operationPalette[index % operationPalette.length];
}

/// Expone el color de acento vigente al subárbol (ver [AppColors] arriba).
/// [TerminalScaffold] lo planta una vez por página; los widgets
/// compartidos (secciones, tarjetas, contadores) lo leen en vez de usar
/// [AppColors.red] a fuego, así heredan el color del módulo actual sin
/// que cada uno reciba el color por parámetro.
class AccentScope extends InheritedWidget {
  final Color color;
  const AccentScope({super.key, required this.color, required super.child});

  static Color of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AccentScope>()?.color ??
      AppColors.red;

  @override
  bool updateShouldNotify(AccentScope oldWidget) => color != oldWidget.color;
}

/// Estilo tipo "display digital" (LCD / siete segmentos) para números
/// sueltos: grados de rotación, tamaño de fuente, opacidad, contadores.
/// NOTA: "Digit-7" no está en Google Fonts ni en assets/, así que se usa
/// VT323 (also LCD-style) como reemplazo — si consigues el .ttf real,
/// se agrega a assets/ + pubspec y se cambia aquí por fontFamily local.
class AppTextStyles {
  AppTextStyles._();

  static TextStyle digit({
    double fontSize = 20,
    Color color = AppColors.red,
  }) =>
      GoogleFonts.vt323(
        fontSize: fontSize,
        color: color,
        height: 1,
      );
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

    // Archivo Black: sans geométrica peso 900, misma sensación robusta
    // que Adlam Display pero con letterforms estándar (más "pro" / legible
    // en textos largos y en números).
    final textTheme = GoogleFonts.archivoBlackTextTheme(base.textTheme).copyWith(
      headlineSmall: GoogleFonts.archivoBlack(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        letterSpacing: 1,
        color: AppColors.red,
      ),
      titleMedium: GoogleFonts.archivoBlack(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.3,
        color: AppColors.red,
      ),
      bodyMedium: GoogleFonts.archivoBlack(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.red,
      ),
      bodySmall: GoogleFonts.archivoBlack(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
        color: AppColors.redSoft,
      ),
      labelLarge: GoogleFonts.archivoBlack(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.5,
        color: AppColors.red,
      ),
    );

    final comp = _componentTheme(AppColors.red);
    return base.copyWith(
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.bg,
        foregroundColor: AppColors.red,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.archivoBlack(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: 1,
          color: AppColors.red,
        ),
      ),
      cardTheme: comp.cardTheme,
      dividerTheme: comp.dividerTheme,
      elevatedButtonTheme: comp.elevatedButtonTheme,
      outlinedButtonTheme: comp.outlinedButtonTheme,
      iconTheme: comp.iconTheme,
      listTileTheme: comp.listTileTheme,
      chipTheme: comp.chipTheme,
      progressIndicatorTheme: comp.progressIndicatorTheme,
    );
  }

  /// Recolorea todo el "chrome" del theme (bordes, íconos, botones,
  /// chips, texto) al [accent] del módulo actual — incluido el cuerpo de
  /// texto, así las letras también quedan del color de la función activa.
  /// El negro sigue siendo el fondo (identidad de la app); solo el acento
  /// cambia por módulo.
  static ThemeData accentTheme(BuildContext context, Color accent) {
    final base = Theme.of(context);
    final comp = _componentTheme(accent);
    return base.copyWith(
      cardTheme: comp.cardTheme,
      dividerTheme: comp.dividerTheme,
      elevatedButtonTheme: comp.elevatedButtonTheme,
      outlinedButtonTheme: comp.outlinedButtonTheme,
      iconTheme: comp.iconTheme,
      listTileTheme: comp.listTileTheme,
      chipTheme: comp.chipTheme,
      progressIndicatorTheme: comp.progressIndicatorTheme,
      textTheme: base.textTheme.copyWith(
        headlineSmall: base.textTheme.headlineSmall?.copyWith(color: accent),
        titleMedium: base.textTheme.titleMedium?.copyWith(color: accent),
        bodyMedium: base.textTheme.bodyMedium?.copyWith(color: accent),
        bodySmall: base.textTheme.bodySmall
            ?.copyWith(color: Color.lerp(accent, Colors.white, 0.25)),
        labelLarge: base.textTheme.labelLarge?.copyWith(color: accent),
      ),
    );
  }

  /// Piezas de componentes "Frutiger Aero" — esquinas redondeadas, tinte
  /// de cristal sutil y resplandor — parametrizadas por [accent]. Un solo
  /// lugar para que el look sea consistente en el theme base (rojo) y en
  /// cada [accentTheme] de módulo; los colores no cambian, solo la forma.
  static ThemeData _componentTheme(Color accent) {
    final buttonTextStyle = GoogleFonts.archivoBlack(
      fontWeight: FontWeight.w700,
      letterSpacing: 1,
      fontSize: 12,
    );
    final glassFill = Color.lerp(Colors.black, accent, 0.14)!;
    final pressedFill = Color.lerp(Colors.black, accent, 0.30)!;
    final disabledFill = Color.lerp(Colors.black, AppColors.textDim, 0.08)!;
    return ThemeData(
      cardTheme: CardThemeData(
        color: glassFill,
        elevation: 6,
        shadowColor: accent.withValues(alpha: 0.45),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: accent, width: 1),
        ),
      ),
      dividerTheme: DividerThemeData(color: accent, thickness: 1),
      // Feedback tipo botón "3D" del kit de referencia: al presionar se
      // aplana (baja elevación) y se oscurece un poco — sin necesitar un
      // AnimationController por botón, solo estados del ButtonStyle.
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          animationDuration: const Duration(milliseconds: 90),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) return disabledFill;
            if (states.contains(WidgetState.pressed)) return pressedFill;
            return glassFill;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) =>
              states.contains(WidgetState.disabled) ? AppColors.textDim : accent),
          elevation: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.pressed) ? 1 : 6),
          shadowColor: WidgetStatePropertyAll(accent.withValues(alpha: 0.5)),
          side: WidgetStateProperty.resolveWith((states) => BorderSide(
              color: states.contains(WidgetState.disabled)
                  ? AppColors.textDim
                  : accent,
              width: states.contains(WidgetState.pressed) ? 0.5 : 1)),
          textStyle: WidgetStatePropertyAll(buttonTextStyle),
          shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
          padding: const WidgetStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 24, vertical: 14)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: accent,
          side: BorderSide(color: accent, width: 1),
          textStyle: buttonTextStyle,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
      ),
      iconTheme: IconThemeData(color: accent),
      listTileTheme: ListTileThemeData(iconColor: accent, textColor: accent),
      chipTheme: ChipThemeData(
        backgroundColor: glassFill,
        shape: StadiumBorder(side: BorderSide(color: accent)),
        side: BorderSide(color: accent),
        labelStyle: GoogleFonts.archivoBlack(
            fontSize: 11, fontWeight: FontWeight.w700, color: accent),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: accent,
        linearTrackColor: Color.lerp(accent, Colors.black, 0.75),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}