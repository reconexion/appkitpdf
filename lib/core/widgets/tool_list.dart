import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'animations.dart';
import 'app_scaffold.dart';

/// Una herramienta de una categoría: ícono + verbo literal, nunca solo
/// ícono — el usuario debe entender qué hace sin tocarlo.
class ToolItem {
  final IconData icon;
  final String title;
  final Widget page;

  const ToolItem({required this.icon, required this.title, required this.page});
}

/// Tarjeta de categoría en Home: relleno plano del color de la
/// categoría, insignia circular negra con el ícono y título en negro —
/// toca para ver la lista de herramientas de la categoría.
class CategoryCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final List<ToolItem> items;

  const CategoryCard({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () => Navigator.push(
        context,
        slidePageRoute(CategoryToolsPage(label: label, color: color, items: items)),
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: AppTheme.colorCard(color, radius: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlackBadge(icon: icon),
            Expanded(
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppColors.cardText, fontSize: 15.5, height: 1.15)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Pantalla intermedia: grid de herramientas de una categoría, cada una
/// en una variante de tono del color de la categoría (misma familia de
/// color, ritmo visual entre tarjetas) — se abre al tocar una
/// [CategoryCard] en Home.
class CategoryToolsPage extends StatelessWidget {
  final String label;
  final Color color;
  final List<ToolItem> items;

  const CategoryToolsPage({
    super.key,
    required this.label,
    required this.color,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final shades = [color, AppTheme.shade(color, -14), AppTheme.shade(color, 14)];
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppHeader(title: label, titleColor: color),
      body: GridView.builder(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.88,
        ),
        itemCount: items.length,
        itemBuilder: (context, i) =>
            ToolCard(item: items[i], cardColor: shades[i % shades.length]),
      ),
    );
  }
}

/// Tarjeta de herramienta dentro de [CategoryToolsPage]: mismo lenguaje
/// visual que [CategoryCard] pero centrada y más compacta para caber en
/// un grid de 2 columnas.
class ToolCard extends StatelessWidget {
  final ToolItem item;
  final Color cardColor;

  const ToolCard({super.key, required this.item, required this.cardColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => Navigator.push(context, slidePageRoute(item.page)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: AppTheme.colorCard(cardColor, radius: 18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            BlackBadge(icon: item.icon, size: 32, iconSize: 15),
            const SizedBox(height: 10),
            Flexible(
              child: Text(
                item.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.cardText, fontWeight: FontWeight.w700, fontSize: 12.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
