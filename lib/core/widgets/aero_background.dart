import 'package:flutter/material.dart';

/// Fondo "Frutiger Aero" adaptado a la identidad negro + rojo/acento de
/// la app: un degradado casi negro (no plano) con dos resplandores suaves
/// del color del módulo flotando detrás del contenido — el mismo recurso
/// del kit de referencia (cielo + glows), pero oscuro y discreto en vez
/// de un cielo celeste, para mantener la seriedad de la app.
class AeroBackground extends StatelessWidget {
  final Color accent;
  final Widget child;
  const AeroBackground({super.key, required this.accent, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0A0A0A), Colors.black],
              ),
            ),
          ),
        ),
        Positioned(top: -90, left: -60, child: _glow(260, accent, 0.16)),
        Positioned(top: 220, right: -80, child: _glow(220, accent, 0.10)),
        Positioned(bottom: -100, left: 40, child: _glow(240, accent, 0.08)),
        child,
      ],
    );
  }

  Widget _glow(double size, Color color, double opacity) => IgnorePointer(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [color.withValues(alpha: opacity), color.withValues(alpha: 0)],
            ),
          ),
        ),
      );
}
