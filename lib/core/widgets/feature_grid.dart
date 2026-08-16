import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'animations.dart';

/// One entry in a [FeatureGrid]: icon + title (+ optional subtitle) that
/// navigates to [page] when tapped.
class FeatureGridItem {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget page;

  const FeatureGridItem({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.page,
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

/// Celda cuadrada tipo botón de panel de control: icono grande arriba,
/// título abajo. Al presionar, el borde brilla más fuerte por un instante
/// (glow animado) para dar feedback claro de que es tocable.
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
          glow: _pressController,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.red, width: 1),
                  ),
                  child: Icon(f.icon, color: AppColors.red, size: 26),
                ),
                const SizedBox(height: 14),
                Text(
                  f.title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(height: 1.25),
                ),
                if (f.subtitle != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    f.subtitle!,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(height: 1.35),
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

/// Panel con borde rojo y esquinas reforzadas. Si se le pasa [glow],
/// el borde se anima a un rojo más brillante cuando el usuario presiona
/// (feedback táctil claro sin usar sombras ni blur — barato en cualquier
/// gama de celular, ya que solo interpola un color).
class FeatureBracketPanel extends StatelessWidget {
  final Widget child;
  final Animation<double>? glow;
  const FeatureBracketPanel({super.key, required this.child, this.glow});

  @override
  Widget build(BuildContext context) {
    if (glow == null) {
      return _panel(AppColors.red, child);
    }
    return AnimatedBuilder(
      animation: glow!,
      builder: (context, _) {
        final color =
        Color.lerp(AppColors.red, AppColors.redSoft, glow!.value)!;
        return _panel(color, child);
      },
    );
  }

  Widget _panel(Color borderColor, Widget child) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.fromBorderSide(BorderSide(color: borderColor, width: 1)),
      ),
      child: CustomPaint(
        painter: _CornerPainter(color: borderColor),
        child: child,
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  final Color color;
  const _CornerPainter({this.color = AppColors.red});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2;
    const len = 14.0;

    // Esquina superior izquierda
    canvas.drawLine(const Offset(-1, 0), const Offset(len, 0), paint);
    canvas.drawLine(const Offset(0, -1), const Offset(0, len), paint);

    // Esquina inferior derecha
    canvas.drawLine(
        Offset(size.width - len, size.height), Offset(size.width + 1, size.height), paint);
    canvas.drawLine(
        Offset(size.width, size.height - len), Offset(size.width, size.height + 1), paint);
  }

  @override
  bool shouldRepaint(covariant _CornerPainter oldDelegate) =>
      oldDelegate.color != color;
}
