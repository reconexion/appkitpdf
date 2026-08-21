import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:provider/provider.dart';
import '../../../../core/controllers/recent_files_controller.dart';
import '../../../../core/l10n/app_strings.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/file_utils.dart';
import '../../../../core/widgets/app_scaffold.dart';

/// Archivos que produjo cualquier herramienta, más recientes primero.
/// [ResultCard] los registra automáticamente en cuanto una operación
/// termina con éxito — esta pantalla solo los lista.
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
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              itemCount: files.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, i) => _RecentTile(file: files[i]),
            ),
    );
  }
}

class _RecentTile extends StatelessWidget {
  final RecentFile file;
  const _RecentTile({required this.file});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => OpenFilex.open(file.path),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: AppTheme.card(),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.textTertiary, width: 1.2),
              ),
              child: const Icon(Icons.picture_as_pdf_outlined,
                  color: AppColors.textSecondary, size: 19),
            ),
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
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '${FileUtils.formatFileSize(file.sizeBytes)} • '
                    '${FileUtils.formatRecentDate(file.processedAt, todayLabel: t.todayLabel)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: t.removeFromList,
              icon: const Icon(Icons.close, size: 18, color: AppColors.textTertiary),
              onPressed: () => context.read<RecentFilesController>().remove(file.path),
            ),
          ],
        ),
      ),
    );
  }
}
