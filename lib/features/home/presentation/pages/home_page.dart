import 'package:flutter/material.dart';
import '../../../../core/l10n/app_strings.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/tool_list.dart';
import '../../../conversion/presentation/pages/conversion_page.dart';
import '../../../editing/presentation/pages/editing_page.dart';
import '../../../extras/presentation/pages/extras_page.dart';
import '../../../organization/presentation/pages/organization_page.dart';
import '../../../security/presentation/pages/security_page.dart';
import 'recent_page.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final tabs = const [_HomeTab(), RecentPage(), SettingsPage()];
    return Scaffold(
      backgroundColor: AppColors.bg,
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: IndexedStack(index: _tabIndex, children: tabs),
      ),
      bottomNavigationBar: _BottomNavBar(
        index: _tabIndex,
        onChanged: (i) => setState(() => _tabIndex = i),
      ),
    );
  }
}

/// Tarjetas grandes por categoría, en relleno plano del color de la
/// categoría — un tap desde Home lleva a la lista de herramientas.
class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 110),
        children: [
          const _HomeHeaderBlock(),
          const SizedBox(height: 24),
          Text(t.categoriesLabel.toUpperCase(),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textTertiary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6)),
          const SizedBox(height: 10),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.90,
            children: [
              CategoryCard(
                label: t.organizationTitle,
                icon: Icons.dashboard_outlined,
                color: AppColors.categoryOrganization,
                items: organizationTools(context),
              ),
              CategoryCard(
                label: t.conversionTitle,
                icon: Icons.swap_horiz,
                color: AppColors.categoryConversion,
                items: conversionTools(context),
              ),
              CategoryCard(
                label: t.editingTitle,
                icon: Icons.edit_outlined,
                color: AppColors.categoryEditing,
                items: editingTools(context),
              ),
              CategoryCard(
                label: t.securityTitle,
                icon: Icons.lock_outline,
                color: AppColors.categorySecurity,
                items: securityTools(context),
              ),
              CategoryCard(
                label: t.extrasTitle,
                icon: Icons.auto_fix_high,
                color: AppColors.categoryExtras,
                items: extrasTools(context),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: AppTheme.card(),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.shield_outlined, color: AppColors.success, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    t.privacyNote,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColors.textSecondary, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Encabezado de la pestaña Inicio: logo + nombre de la app y un
/// titular corto — el único lugar de la app donde aparece el logotipo
/// completo. Es un bloque normal dentro del scroll (no un appBar de
/// altura fija), así el titular de dos líneas nunca se recorta sin
/// importar el alto de la barra de estado del dispositivo.
class _HomeHeaderBlock extends StatelessWidget {
  const _HomeHeaderBlock();

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Container(
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.red,
                borderRadius: BorderRadius.circular(9),
                boxShadow: [
                  BoxShadow(color: AppColors.red.withValues(alpha: 0.4), blurRadius: 14),
                ],
              ),
              child: const Icon(Icons.picture_as_pdf_outlined, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                t.appTitle,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 19),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          t.homeHeadline,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 26, height: 1.15),
        ),
      ],
    );
  }
}

/// Barra inferior flotante tipo vidrio esmerilado, solo íconos — la
/// pestaña activa lleva un círculo rojo detrás.
class _BottomNavBar extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;
  const _BottomNavBar({required this.index, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.home_rounded, Icons.home_outlined),
      (Icons.schedule, Icons.schedule_outlined),
      (Icons.settings_rounded, Icons.settings_outlined),
    ];
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: SafeArea(
        top: false,
        child: GlassPill(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (i) {
              final active = i == index;
              final (activeIcon, inactiveIcon) = items[i];
              return InkWell(
                borderRadius: BorderRadius.circular(999),
                onTap: () => onChanged(i),
                child: Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: active ? AppColors.red : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    active ? activeIcon : inactiveIcon,
                    color: active ? Colors.white : AppColors.textTertiary,
                    size: 19,
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
