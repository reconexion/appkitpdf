import 'package:flutter/material.dart';
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
    final features = [
      _Feature(
        icon: Icons.folder_copy,
        color: Colors.indigo,
        title: 'Organization',
        subtitle: 'Merge · Split · Remove · Extract · Reorder · Rotate',
        page: const OrganizationPage(),
      ),
      _Feature(
        icon: Icons.swap_horiz,
        color: Colors.teal,
        title: 'Conversion',
        subtitle: 'PDF↔Word · PDF↔Excel · PDF↔PPT · PDF↔Images · HTML→PDF',
        page: const ConversionPage(),
      ),
      _Feature(
        icon: Icons.edit_document,
        color: Colors.deepOrange,
        title: 'Editing',
        subtitle: 'Add page numbers · Text overlay / Watermark',
        page: const EditingPage(),
      ),
      _Feature(
        icon: Icons.lock,
        color: Colors.blueGrey,
        title: 'Security',
        subtitle: 'Password protect · Unprotect · Compress',
        page: const SecurityPage(),
      ),
      _Feature(
        icon: Icons.auto_awesome,
        color: Colors.purple,
        title: 'Extras',
        subtitle: 'OCR · Compare PDFs · Repair corrupted PDF',
        page: const ExtrasPage(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Kit'),
        centerTitle: false,
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
