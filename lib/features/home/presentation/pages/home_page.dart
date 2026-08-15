import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/l10n/app_strings.dart';
import '../../../../core/widgets/animations.dart';
import '../../../conversion/presentation/pages/conversion_page.dart';
import '../../../editing/presentation/pages/editing_page.dart';
import '../../../extras/presentation/pages/extras_page.dart';
import '../../../organization/presentation/pages/organization_page.dart';
import '../../../security/presentation/pages/security_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final features = [
      _Feature(
        icon: Icons.folder_copy,
        color: Colors.indigo,
        title: t.organizationTitle,
        subtitle: t.organizationSubtitle,
        page: const OrganizationPage(),
      ),
      _Feature(
        icon: Icons.swap_horiz,
        color: Colors.teal,
        title: t.conversionTitle,
        subtitle: t.conversionSubtitle,
        page: const ConversionPage(),
      ),
      _Feature(
        icon: Icons.edit_document,
        color: Colors.deepOrange,
        title: t.editingTitle,
        subtitle: t.editingSubtitle,
        page: const EditingPage(),
      ),
      _Feature(
        icon: Icons.lock,
        color: Colors.blueGrey,
        title: t.securityTitle,
        subtitle: t.securitySubtitle,
        page: const SecurityPage(),
      ),
      _Feature(
        icon: Icons.auto_awesome,
        color: Colors.purple,
        title: t.extrasTitle,
        subtitle: t.extrasSubtitle,
        page: const ExtrasPage(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(t.appTitle),
        centerTitle: false,
        actions: const [_LanguageSwitch()],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
        itemCount: features.length,
        itemBuilder: (context, i) => FadeSlideIn(
          index: i,
          child: _FeatureTile(feature: features[i]),
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
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Tooltip(
        message: context.t.languageTooltip,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: controller.toggle,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.language, size: 18),
                const SizedBox(width: 4),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    isEn ? 'EN' : 'ES',
                    key: ValueKey(isEn),
                    style: const TextStyle(fontWeight: FontWeight.bold),
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

class _Feature {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final Widget page;

  const _Feature({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.page,
  });
}

class _FeatureTile extends StatefulWidget {
  final _Feature feature;
  const _FeatureTile({required this.feature});

  @override
  State<_FeatureTile> createState() => _FeatureTileState();
}

class _FeatureTileState extends State<_FeatureTile> {
  double _scale = 1;

  void _setPressed(bool pressed) => setState(() => _scale = pressed ? 0.97 : 1);

  @override
  Widget build(BuildContext context) {
    final f = widget.feature;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Material(
          color: Theme.of(context).colorScheme.surface,
          elevation: 1,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => Navigator.push(context, slidePageRoute(f.page)),
            onTapDown: (_) => _setPressed(true),
            onTapCancel: () => _setPressed(false),
            onTapUp: (_) => _setPressed(false),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: f.color.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(f.icon, color: f.color, size: 26),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(f.title,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 2),
                        Text(f.subtitle,
                            style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant)),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right,
                      color: Theme.of(context).colorScheme.outline),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
