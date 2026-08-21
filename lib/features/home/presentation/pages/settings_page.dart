import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/l10n/app_strings.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_scaffold.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final controller = context.watch<LocaleController>();
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppHeader(title: t.settingsTitle, showBack: false),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        children: [
          FieldLabel(text: t.languageTooltip.toUpperCase()),
          Container(
            decoration: AppTheme.card(),
            child: Column(
              children: [
                _LanguageOption(
                  label: 'English',
                  selected: controller.language == AppLanguage.en,
                  onTap: () => controller.setLanguage(AppLanguage.en),
                ),
                const Divider(height: 1, indent: 16),
                _LanguageOption(
                  label: 'Español',
                  selected: controller.language == AppLanguage.es,
                  onTap: () => controller.setLanguage(AppLanguage.es),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          FieldLabel(text: t.privacyTitle.toUpperCase()),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
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
                        .bodyMedium
                        ?.copyWith(color: AppColors.textSecondary, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          Center(
            child: Text(
              '${t.appTitle} · ${t.aboutVersion}',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.textTertiary),
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
            ),
            if (selected) const Icon(Icons.check, color: AppColors.red, size: 20),
          ],
        ),
      ),
    );
  }
}
