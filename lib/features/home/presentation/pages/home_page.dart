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

/// Tarjetas grandes por categoría — un tap desde Home lleva a la lista de
/// herramientas de esa categoría, y otro tap más a la herramienta. Cada
/// tarjeta lleva su acento (contorno/texto), nunca como fondo.
class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: const _HomeHeader(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 32),
        children: [
          CategoryCard(
            label: t.organizationTitle,
            icon: Icons.merge_type,
            color: AppColors.categoryOrganization,
            items: organizationTools(context),
          ),
          const SizedBox(height: 12),
          CategoryCard(
            label: t.conversionTitle,
            icon: Icons.swap_horiz,
            color: AppColors.categoryConversion,
            items: conversionTools(context),
          ),
          const SizedBox(height: 12),
          CategoryCard(
            label: t.editingTitle,
            icon: Icons.edit_outlined,
            color: AppColors.categoryEditing,
            items: editingTools(context),
          ),
          const SizedBox(height: 12),
          CategoryCard(
            label: t.securityTitle,
            icon: Icons.lock_outline,
            color: AppColors.categorySecurity,
            items: securityTools(context),
          ),
          const SizedBox(height: 12),
          CategoryCard(
            label: t.extrasTitle,
            icon: Icons.auto_fix_high,
            color: AppColors.categoryExtras,
            items: extrasTools(context),
          ),
        ],
      ),
    );
  }
}

/// Header de la pestaña Inicio: logo de marca + nombre de la app, con
/// una línea de posicionamiento debajo — el único lugar de la app donde
/// aparece el logotipo completo.
class _HomeHeader extends StatelessWidget implements PreferredSizeWidget {
  const _HomeHeader();

  @override
  Size get preferredSize => const Size.fromHeight(86);

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 14),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Image.asset('assets/logo.png', height: 32),
                const SizedBox(width: 10),
                Text(
                  t.appTitle,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.textPrimary, fontSize: 21, letterSpacing: -0.3),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.only(left: 42),
              child: RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textTertiary,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3),
                  children: [
                    const TextSpan(text: 'hi'),
                    TextSpan(
                      text: ':>',
                      style: const TextStyle(color: AppColors.red, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ),
          ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;
  const _BottomNavBar({required this.index, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final items = [
      (Icons.home_rounded, Icons.home_outlined, t.navHome),
      (Icons.schedule, Icons.schedule_outlined, t.navRecent),
      (Icons.settings_rounded, Icons.settings_outlined, t.settingsTitle),
    ];
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            children: List.generate(items.length, (i) {
              final active = i == index;
              final (activeIcon, inactiveIcon, label) = items[i];
              return Expanded(
                child: InkWell(
                  onTap: () => onChanged(i),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        active ? activeIcon : inactiveIcon,
                        color: active ? AppColors.red : AppColors.textTertiary,
                        size: 21,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        label,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: active ? AppColors.red : AppColors.textTertiary,
                            fontSize: 10.5,
                            fontWeight: active ? FontWeight.w600 : FontWeight.w500),
                      ),
                      const SizedBox(height: 3),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        width: 3.5,
                        height: 3.5,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: active ? AppColors.red : Colors.transparent,
                        ),
                      ),
                    ],
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
