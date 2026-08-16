import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'aero_background.dart';
import 'animations.dart';
import 'glass_panel.dart';

/// Scaffold estándar para las páginas de features: mismo header
/// "terminal" que la home, con botón de volver y título arriba.
/// Reemplaza al AppBar de Material por consistencia visual.
class TerminalScaffold extends StatelessWidget {
  final String title;
  final String tag;
  final Widget body;
  final List<Widget>? actions;

  /// Color del módulo actual (Organización, Conversión, etc). El negro +
  /// rojo por defecto sigue siendo la identidad de la app en las páginas
  /// que no pasan uno explícito.
  final Color accent;

  const TerminalScaffold({
    super.key,
    required this.title,
    required this.tag,
    required this.body,
    this.actions,
    this.accent = AppColors.red,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.accentTheme(context, accent),
      child: AccentScope(
        color: accent,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: AeroBackground(
            accent: accent,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FadeSlideIn(
                    index: 0,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(4, 8, 16, 14),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.55),
                            Color.lerp(Colors.black, accent, 0.18)!
                                .withValues(alpha: 0.55),
                          ],
                        ),
                        border: Border(bottom: BorderSide(color: accent, width: 1)),
                        boxShadow: [
                          BoxShadow(
                            color: accent.withValues(alpha: 0.3),
                            blurRadius: 14,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: Icon(Icons.arrow_back, size: 20, color: accent),
                          ),
                          Expanded(
                            child: Text(title,
                                style: Theme.of(context).textTheme.headlineSmall),
                          ),
                          if (actions != null) ...actions!,
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: FadeSlideIn(index: 1, child: body),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Reemplaza el ExpansionTile repetido en cada página. Panel plano con
/// esquina superior izquierda en L y título en mayúsculas tipo etiqueta.
/// Empieza cerrado para no saturar la pantalla de golpe.
class TerminalSection extends StatefulWidget {
  final String title;
  final List<Widget> children;
  final bool initiallyExpanded;

  const TerminalSection({
    super.key,
    required this.title,
    required this.children,
    this.initiallyExpanded = false,
  });

  @override
  State<TerminalSection> createState() => _TerminalSectionState();
}

class _TerminalSectionState extends State<TerminalSection> {
  late bool _open = widget.initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    final accent = AccentScope.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GlassPanel(
        accent: accent,
        radius: 16,
        glow: 0.2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InkWell(
              onTap: () => setState(() => _open = !_open),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.title.toUpperCase(),
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                    AnimatedRotation(
                      turns: _open ? 0.5 : 0,
                      duration: const Duration(milliseconds: 180),
                      child: Icon(Icons.expand_more, size: 18, color: accent),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 180),
              crossFadeState:
              _open ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              firstChild: Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: widget.children,
                ),
              ),
              secondChild: const SizedBox(width: double.infinity),
            ),
          ],
        ),
      ),
    );
  }
}

/// Fila de estado tipo "REF / LOT" con dos textos alineados a los extremos.
/// Útil para mostrar metadatos (nombre de archivo, tamaño, cantidad).
class TerminalStatRow extends StatelessWidget {
  final String label;
  final String value;

  const TerminalStatRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label.toUpperCase(), style: Theme.of(context).textTheme.bodySmall),
          Text(value,
              style: AppTextStyles.digit(
                  fontSize: 16, color: AccentScope.of(context))),
        ],
      ),
    );
  }
}