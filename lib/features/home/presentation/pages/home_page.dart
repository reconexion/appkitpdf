import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/l10n/app_strings.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/aero_background.dart';
import '../../../../core/widgets/feature_grid.dart';
import '../../../conversion/presentation/pages/conversion_page.dart';
import '../../../editing/presentation/pages/editing_page.dart';
import '../../../extras/presentation/pages/extras_page.dart';
import '../../../organization/presentation/pages/organization_page.dart';
import '../../../organization/presentation/pages/rename_page.dart';
import '../../../security/presentation/pages/security_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final features = [
      FeatureGridItem(
        icon: Icons.folder_copy_outlined,
        title: t.organizationTitle,
        subtitle: t.organizationSubtitle,
        color: AppColors.accentOrganization,
        page: const OrganizationPage(),
      ),
      FeatureGridItem(
        icon: Icons.swap_horiz,
        title: t.conversionTitle,
        subtitle: t.conversionSubtitle,
        color: AppColors.accentConversion,
        page: const ConversionPage(),
      ),
      FeatureGridItem(
        icon: Icons.edit_document,
        title: t.editingTitle,
        subtitle: t.editingSubtitle,
        color: AppColors.accentEditing,
        page: const EditingPage(),
      ),
      FeatureGridItem(
        icon: Icons.lock_outline,
        title: t.securityTitle,
        subtitle: t.securitySubtitle,
        color: AppColors.accentSecurity,
        page: const SecurityPage(),
      ),
      FeatureGridItem(
        icon: Icons.auto_awesome_outlined,
        title: t.extrasTitle,
        subtitle: t.extrasSubtitle,
        color: AppColors.accentExtras,
        page: const ExtrasPage(),
      ),
      FeatureGridItem(
        icon: Icons.drive_file_rename_outline,
        title: t.renameTitle,
        subtitle: t.renameSubtitle,
        color: AppColors.accentRename,
        page: const RenamePage(),
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AeroBackground(
        accent: AppColors.red,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _TitleBar(appTitle: t.appTitle),
              Expanded(child: FeatureGrid(items: features)),
            ],
          ),
        ),
      ),
    );
  }
}

class _TitleBar extends StatelessWidget {
  final String appTitle;
  const _TitleBar({required this.appTitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 22, 16, 16),
      child: SizedBox(
        height: 44,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Logo row: mark + app title.
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/logo.png', height: 38),
                const SizedBox(width: 10),
                Text(
                  appTitle,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontSize: 30,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
            const Align(
              alignment: Alignment.centerRight,
              child: _LanguageSwitch(),
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageSwitch extends StatelessWidget {
  const _LanguageSwitch();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<LocaleController>();
    final isEn = controller.language == AppLanguage.en;
    return Tooltip(
      message: context.t.languageTooltip,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: controller.toggle,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF260909), Colors.black],
            ),
            border: Border.all(color: AppColors.red),
            boxShadow: [
              BoxShadow(
                color: AppColors.red.withValues(alpha: 0.3),
                blurRadius: 10,
                spreadRadius: -2,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.language, size: 14),
              const SizedBox(width: 4),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Text(
                  isEn ? 'EN' : 'ES',
                  key: ValueKey(isEn),
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
