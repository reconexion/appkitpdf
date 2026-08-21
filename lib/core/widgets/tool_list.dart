import 'package:flutter/material.dart';
import '../l10n/app_strings.dart';
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

/// Tarjeta grande de categoría en Home: ícono + nombre + cuántas
/// herramientas trae, en el color de esa categoría (contorno y texto,
/// nunca relleno). Toca para ver la lista de herramientas de la categoría.
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
    final t = context.t;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => Navigator.push(
        context,
        slidePageRoute(CategoryToolsPage(label: label, color: color, items: items)),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        decoration: AppTheme.card(radius: 16, borderColor: color, borderWidth: 1.3),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 1.5),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(label,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: color, fontSize: 16.5, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 3),
                  Text(t.toolsCount(items.length),
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: AppColors.textSecondary)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textTertiary, size: 20),
          ],
        ),
      ),
    );
  }
}

/// Pantalla intermedia: lista de herramientas de una categoría, en el
/// color de esa categoría — se abre al tocar una [CategoryCard] en Home.
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
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppHeader(title: label, titleColor: color),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(height: 9),
        itemBuilder: (context, i) => ToolRow(item: items[i], color: color),
      ),
    );
  }
}

/// Una fila de herramienta dentro de [CategoryToolsPage]: ícono + verbo
/// literal + flecha — mismo lenguaje visual que Recientes.
class ToolRow extends StatelessWidget {
  final ToolItem item;
  final Color color;

  const ToolRow({super.key, required this.item, required this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => Navigator.push(context, slidePageRoute(item.page)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
        decoration: AppTheme.card(radius: 14),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: color, width: 1.2),
              ),
              child: Icon(item.icon, color: color, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item.title,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textTertiary, size: 18),
          ],
        ),
      ),
    );
  }
}
