import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';

/// Panel de vidrio esmerilado ("Frutiger Aero"): el mismo recurso que el
/// kit de referencia (BackdropFilter + degradado translúcido + borde +
/// sombra) pero tintado con el [accent] del módulo sobre negro en vez de
/// blanco sobre celeste — mantiene la identidad negro + rojo/acento,
/// solo cambia la superficie de plana a un cristal pulido con reflejo
/// superior y desenfoque real de lo que hay detrás (usar sobre
/// [AeroBackground] para que el blur tenga algo que desenfocar).
class GlassPanel extends StatelessWidget {
  final Color accent;
  final Widget child;
  final double radius;
  final EdgeInsetsGeometry? padding;
  final double glow;
  final double tint;

  const GlassPanel({
    super.key,
    required this.accent,
    required this.child,
    this.radius = 16,
    this.padding,
    this.glow = 0.35,
    this.tint = 0.22,
  });

  @override
  Widget build(BuildContext context) {
    final content = padding != null ? Padding(padding: padding!, child: child) : child;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: glow),
            blurRadius: 20,
            spreadRadius: -6,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0, 0.7],
                colors: [
                  Color.lerp(Colors.black, accent, tint)!.withValues(alpha: 0.82),
                  Colors.black.withValues(alpha: 0.78),
                ],
              ),
              border: Border.all(color: accent.withValues(alpha: 0.9), width: 1),
            ),
            child: Stack(
              children: [
                content,
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: IgnorePointer(
                    child: Container(
                      height: 24,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withValues(alpha: 0.16),
                            Colors.white.withValues(alpha: 0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
