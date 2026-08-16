import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'animations.dart';
import 'glass_panel.dart';

/// One entry in a [FeatureGrid]: icon + title (+ optional subtitle) that
/// navigates to [page] when tapped.
class FeatureGridItem {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget page;

  /// Color de esta tarjeta. Si es null, hereda el [AccentScope] ambiente
  /// (así las sub-tarjetas dentro de un módulo no necesitan repetirlo).
  /// La Home sí lo fija explícito por ítem, uno distinto por función.
  final Color? color;

  const FeatureGridItem({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.page,
    this.color,
  });
}

/// 2-per-row grid of [FeatureGridItem] tiles. Used both by the Home page
/// (feature selector) and by each feature page (operation selector), so
/// the whole app drills down through the same "grid of icons" pattern.
class FeatureGrid extends StatelessWidget {
  final List<FeatureGridItem> items;
  final EdgeInsetsGeometry padding;

  const FeatureGrid({
    super.key,
    required this.items,
    this.padding = const EdgeInsets.fromLTRB(16, 4, 16, 24),
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: padding,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.86,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: items.length,
      itemBuilder: (context, i) => FadeSlideIn(
        index: i,
        child: FeatureTile(item: items[i]),
      ),
    );
  }
}

/// Celda tipo panel de control: título arriba a la izquierda, ícono como
/// acento en la esquina inferior izquierda (en vez de centrado). Al
/// presionar, el borde brilla más fuerte por un instante (glow animado)
/// para dar feedback claro de que es tocable.
class FeatureTile extends StatefulWidget {
  final FeatureGridItem item;
  const FeatureTile({super.key, required this.item});

  @override
  State<FeatureTile> createState() => _FeatureTileState();
}

class _FeatureTileState extends State<FeatureTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 160),
    reverseDuration: const Duration(milliseconds: 220),
  );

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  void _onTapDown(_) => _pressController.forward();
  void _onTapEnd() => _pressController.reverse();

  @override
  Widget build(BuildContext context) {
    final f = widget.item;
    final accent = f.color ?? AccentScope.of(context);
    return AnimatedBuilder(
      animation: _pressController,
      builder: (context, child) {
        final t = _pressController.value;
        final scale = 1 - (t * 0.04);
        return Transform.scale(scale: scale, child: child);
      },
      child: InkWell(
        onTap: () => Navigator.push(context, slidePageRoute(f.page)),
        onTapDown: _onTapDown,
        onTapCancel: _onTapEnd,
        onTapUp: (_) => _onTapEnd(),
        child: FeatureBracketPanel(
          color: accent,
          glow: _pressController,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 18, 14, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color.lerp(Colors.black, accent, 0.3)!,
                          Colors.black,
                        ],
                      ),
                      border: Border.all(color: accent, width: 1),
                    ),
                    child: Icon(f.icon, color: accent, size: 22),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  f.title,
                  textAlign: TextAlign.left,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(height: 1.15, fontWeight: FontWeight.w900),
                ),
                if (f.subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    f.subtitle!,
                    textAlign: TextAlign.left,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(height: 1.3),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Panel de cristal ("Frutiger Aero"): esquinas redondeadas, degradado y
/// resplandor del color del módulo. Si se le pasa [glow], el brillo del
/// borde se intensifica un instante cuando el usuario presiona (feedback
/// táctil, solo interpola color, barato en cualquier gama de celular).
class FeatureBracketPanel extends StatelessWidget {
  final Widget child;
  final Color color;
  final Animation<double>? glow;
  const FeatureBracketPanel({
    super.key,
    required this.child,
    this.color = AppColors.red,
    this.glow,
  });

  @override
  Widget build(BuildContext context) {
    if (glow == null) {
      return GlassPanel(accent: color, radius: 18, child: child);
    }
    final soft = Color.lerp(color, Colors.white, 0.35)!;
    return AnimatedBuilder(
      animation: glow!,
      builder: (context, _) {
        final liveColor = Color.lerp(color, soft, glow!.value)!;
        return GlassPanel(
          accent: liveColor,
          radius: 18,
          glow: 0.25 + glow!.value * 0.3,
          child: child,
        );
      },
    );
  }
}
