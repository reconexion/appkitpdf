import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:share_plus/share_plus.dart';
import '../l10n/app_strings.dart';
import '../result/result.dart';

class ResultCard extends StatelessWidget {
  final OperationResult? result;
  final bool isLoading;

  const ResultCard({super.key, this.result, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
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
    if (isLoading) {
      return Padding(
        key: const ValueKey('loading'),
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const LinearProgressIndicator(),
            const SizedBox(height: 8),
            Text(t.processing),
          ],
        ),
      );
    }
    if (result == null) return const SizedBox.shrink(key: ValueKey('empty'));

    if (!result!.isSuccess) {
      return Container(
        key: const ValueKey('error'),
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.red.shade200),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.error_outline, color: Colors.red.shade700, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(t.errorMessage(result!.error ?? ''),
                  style: TextStyle(color: Colors.red.shade800)),
            ),
          ],
        ),
      );
    }

    final paths = result!.outputPaths ??
        (result!.outputPath != null ? [result!.outputPath!] : []);

    return Container(
      key: const ValueKey('success'),
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 350),
                curve: Curves.elasticOut,
                builder: (context, v, child) =>
                    Transform.scale(scale: v, child: child),
                child: Icon(Icons.check_circle,
                    color: Colors.green.shade700, size: 20),
              ),
              const SizedBox(width: 6),
              Text(t.done,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade800)),
            ],
          ),
          const SizedBox(height: 4),
          ...paths.map((p) => Text(p.split('/').last,
              style: const TextStyle(fontSize: 12))),
          const SizedBox(height: 8),
          Row(
            children: [
              if (paths.isNotEmpty)
                TextButton.icon(
                  icon: const Icon(Icons.open_in_new, size: 16),
                  label: Text(t.open),
                  onPressed: () => OpenFilex.open(paths.first),
                ),
              if (paths.isNotEmpty)
                TextButton.icon(
                  icon: const Icon(Icons.share, size: 16),
                  label: Text(t.share),
                  onPressed: () => Share.shareXFiles(
                      paths.map((p) => XFile(p)).toList()),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

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
    final selected = path != null;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: selected
            ? Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.35)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: selected
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.4)
              : Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
      child: ListTile(
        dense: true,
        contentPadding: EdgeInsets.zero,
        leading: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Icon(
            selected ? Icons.picture_as_pdf : Icons.upload_file,
            key: ValueKey(selected),
            size: 20,
            color: selected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey,
          ),
        ),
        title: Text(path?.split('/').last ?? label ?? t.noFileSelected,
            style: TextStyle(
                color: selected ? null : Colors.grey,
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 13)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(onPressed: onTap, child: Text(t.select)),
            if (selected && onClear != null)
              IconButton(
                  icon: const Icon(Icons.close, size: 16),
                  onPressed: onClear),
          ],
        ),
      ),
    );
  }
}
