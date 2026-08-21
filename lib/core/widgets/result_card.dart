import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../controllers/recent_files_controller.dart';
import '../l10n/app_strings.dart';
import '../result/result.dart';
import '../theme/app_theme.dart';
import '../utils/file_utils.dart';

/// Feedback de una operación: progreso mientras corre, tarjeta de éxito
/// con acción clara de siguiente paso (abrir / compartir), o error legible.
/// Registra automáticamente el archivo resultante en Recientes la primera
/// vez que [result] pasa a éxito, así ninguna pantalla de herramienta
/// necesita cablear ese seguimiento a mano.
class ResultCard extends StatefulWidget {
  final OperationResult? result;
  final bool isLoading;

  const ResultCard({super.key, this.result, this.isLoading = false});

  @override
  State<ResultCard> createState() => _ResultCardState();
}

class _ResultCardState extends State<ResultCard> {
  OperationResult? _recordedFor;

  @override
  void didUpdateWidget(covariant ResultCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    _maybeRecord();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeRecord());
  }

  void _maybeRecord() {
    final result = widget.result;
    if (result == null || !result.isSuccess || result == _recordedFor) return;
    final paths = result.outputPaths ??
        (result.outputPath != null ? [result.outputPath!] : <String>[]);
    if (paths.isEmpty) return;
    _recordedFor = result;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final controller = context.read<RecentFilesController>();
      for (final p in paths) {
        controller.record(p);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      switchInCurve: Curves.easeOut,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SizeTransition(
          sizeFactor: animation,
          alignment: Alignment.topCenter,
          child: child,
        ),
      ),
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final t = context.t;
    final accent = AccentScope.of(context);

    if (widget.isLoading) {
      return Padding(
        key: const ValueKey('loading'),
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                minHeight: 4,
                color: accent,
                backgroundColor: AppColors.surfaceAlt,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              t.processing,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }
    final result = widget.result;
    if (result == null) return const SizedBox.shrink(key: ValueKey('empty'));

    if (!result.isSuccess) {
      return Container(
        key: const ValueKey('error'),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.redTint,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.red.withValues(alpha: 0.35)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.error_outline, color: AppColors.red, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                t.errorMessage(result.error ?? ''),
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.redPressed, height: 1.4),
              ),
            ),
          ],
        ),
      );
    }

    final paths = result.outputPaths ??
        (result.outputPath != null ? [result.outputPath!] : <String>[]);

    return Container(
      key: const ValueKey('success'),
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.card(borderColor: accent.withValues(alpha: 0.35)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 320),
                curve: Curves.elasticOut,
                builder: (context, v, child) =>
                    Transform.scale(scale: v, child: child),
                child: Icon(Icons.check_circle, color: accent, size: 20),
              ),
              const SizedBox(width: 8),
              Text(t.done, style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
          if (paths.isNotEmpty) ...[
            const SizedBox(height: 10),
            ...paths.map((p) => Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(
                    p.split(RegExp(r'[\\/]')).last,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: AppColors.textSecondary),
                  ),
                )),
          ],
          if (paths.isNotEmpty) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => OpenFilex.open(paths.first),
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 13)),
                    child: Text(t.open),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () =>
                        Share.shareXFiles(paths.map((p) => XFile(p)).toList()),
                    style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 13)),
                    child: Text(t.share),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Selector de archivo grande y claro — nunca solo un ícono. Estado vacío:
/// tap directo al picker nativo, borde punteado en el color de categoría.
/// Estado con archivo: nombre + tamaño, con "Cambiar" como siguiente paso.
class FileTile extends StatelessWidget {
  final String? path;
  final String? label;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  const FileTile({
    super.key,
    required this.path,
    this.label,
    required this.onTap,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final accent = AccentScope.of(context);
    final selected = path != null;

    if (!selected) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: accent, width: 1.4),
          ),
          child: Column(
            children: [
              Icon(Icons.upload_file_outlined, color: accent, size: 26),
              const SizedBox(height: 8),
              Text(
                label ?? t.selectFileCta,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: accent),
              ),
              const SizedBox(height: 2),
              Text(
                t.noFileSelected,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      );
    }

    int sizeBytes = 0;
    try {
      sizeBytes = File(path!).lengthSync();
    } catch (_) {}

    return Container(
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
              border: Border.all(color: accent, width: 1.2),
            ),
            child: Icon(Icons.picture_as_pdf_outlined, color: accent, size: 19),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  path!.split(RegExp(r'[\\/]')).last,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                ),
                Text(FileUtils.formatFileSize(sizeBytes),
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          TextButton(onPressed: onTap, child: Text(t.changeFile)),
          if (onClear != null)
            IconButton(
              icon: const Icon(Icons.close, size: 18, color: AppColors.textTertiary),
              onPressed: onClear,
            ),
        ],
      ),
    );
  }
}
