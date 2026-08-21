import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:provider/provider.dart';
import '../../../../core/controllers/recent_files_controller.dart';
import '../../../../core/l10n/app_strings.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/file_utils.dart';
import '../../../../core/widgets/app_scaffold.dart';

const _kRecentColors = [
  AppColors.categoryOrganization,
  AppColors.categoryConversion,
  AppColors.categoryEditing,
  AppColors.categorySecurity,
  AppColors.categoryExtras,
];

/// Archivos que produjo cualquier herramienta, más recientes primero.
/// [ResultCard] los registra automáticamente en cuanto una operación
/// termina con éxito — esta pantalla solo los lista, cada uno en una
/// tarjeta de color (rotando la paleta de categorías para dar ritmo
/// visual, ya que un archivo reciente no pertenece a una sola categoría).
class RecentPage extends StatelessWidget {
  const RecentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final files = context.watch<RecentFilesController>().all;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppHeader(title: t.navRecent, showBack: false),
      body: files.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.schedule, color: AppColors.textTertiary, size: 34),
                    const SizedBox(height: 12),
                    Text(
                      t.recentEmpty,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
              itemCount: files.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, i) =>
                  _RecentTile(file: files[i], color: _kRecentColors[i % _kRecentColors.length]),
            ),
    );
  }
}

class _RecentTile extends StatelessWidget {
  final RecentFile file;
  final Color color;
  const _RecentTile({required this.file, required this.color});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => OpenFilex.open(file.path),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: AppTheme.colorCard(color, radius: 16),
        child: Row(
          children: [
            const BlackBadge(icon: Icons.picture_as_pdf_outlined, size: 38, iconSize: 17),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    file.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w700, color: AppColors.cardText),
                  ),
                  Text(
                    '${FileUtils.formatFileSize(file.sizeBytes)} • '
                    '${FileUtils.formatRecentDate(file.processedAt, todayLabel: t.todayLabel)}',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColors.cardText.withValues(alpha: 0.65)),
                  ),
                ],
              ),
            ),
            InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: () => context.read<RecentFilesController>().remove(file.path),
              child: Container(
                width: 26,
                height: 26,
                alignment: Alignment.center,
                decoration: const BoxDecoration(color: AppColors.badge, shape: BoxShape.circle),
                child: const Icon(Icons.close, size: 13, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
