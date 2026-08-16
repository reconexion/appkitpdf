import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/l10n/app_strings.dart';
import '../../../../core/theme/app_theme.dart';
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
        page: const OrganizationPage(),
      ),
      FeatureGridItem(
        icon: Icons.swap_horiz,
        title: t.conversionTitle,
        subtitle: t.conversionSubtitle,
        page: const ConversionPage(),
      ),
      FeatureGridItem(
        icon: Icons.edit_document,
        title: t.editingTitle,
        subtitle: t.editingSubtitle,
        page: const EditingPage(),
      ),
      FeatureGridItem(
        icon: Icons.lock_outline,
        title: t.securityTitle,
        subtitle: t.securitySubtitle,
        page: const SecurityPage(),
      ),
      FeatureGridItem(
        icon: Icons.auto_awesome_outlined,
        title: t.extrasTitle,
        subtitle: t.extrasSubtitle,
        page: const ExtrasPage(),
      ),
      FeatureGridItem(
        icon: Icons.drive_file_rename_outline,
        title: t.renameTitle,
        subtitle: t.renameSubtitle,
        page: const RenamePage(),
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TitleBar(appTitle: t.appTitle),
            Expanded(child: FeatureGrid(items: features)),
          ],
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
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
      child: SizedBox(
        height: 32,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(appTitle, style: Theme.of(context).textTheme.headlineSmall),
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
        onTap: controller.toggle,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.red),
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
