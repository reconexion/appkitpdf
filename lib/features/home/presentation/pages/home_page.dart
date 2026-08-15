import 'package:flutter/material.dart';
import '../../../conversion/presentation/pages/conversion_page.dart';
import '../../../editing/presentation/pages/editing_page.dart';
import '../../../extras/presentation/pages/extras_page.dart';
import '../../../organization/presentation/pages/organization_page.dart';
import '../../../security/presentation/pages/security_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PDF Kit')),
      body: ListView(
        children: [
          _FeatureTile(
            icon: Icons.folder_copy,
            title: 'Organization',
            subtitle: 'Merge · Split · Remove · Extract · Reorder · Rotate',
            page: const OrganizationPage(),
          ),
          _FeatureTile(
            icon: Icons.swap_horiz,
            title: 'Conversion',
            subtitle:
                'PDF↔Word · PDF↔Excel · PDF↔PPT · PDF↔Images · HTML→PDF',
            page: const ConversionPage(),
          ),
          _FeatureTile(
            icon: Icons.edit_document,
            title: 'Editing',
            subtitle: 'Add page numbers · Text overlay / Watermark',
            page: const EditingPage(),
          ),
          _FeatureTile(
            icon: Icons.lock,
            title: 'Security',
            subtitle: 'Password protect · Unprotect · Compress',
            page: const SecurityPage(),
          ),
          _FeatureTile(
            icon: Icons.auto_awesome,
            title: 'Extras',
            subtitle: 'OCR · Compare PDFs · Repair corrupted PDF',
            page: const ExtrasPage(),
          ),
        ],
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget page;

  const _FeatureTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 32),
      title: Text(title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: const Icon(Icons.chevron_right),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (_) => page)),
    );
  }
}
