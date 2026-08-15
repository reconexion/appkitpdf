import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:share_plus/share_plus.dart';
import '../result/result.dart';

class ResultCard extends StatelessWidget {
  final OperationResult? result;
  final bool isLoading;

  const ResultCard({super.key, this.result, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            LinearProgressIndicator(),
            SizedBox(height: 8),
            Text('Processing...'),
          ],
        ),
      );
    }
    if (result == null) return const SizedBox.shrink();

    if (!result!.isSuccess) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        color: Colors.red.shade50,
        child: Text('Error: ${result!.error}',
            style: TextStyle(color: Colors.red.shade800)),
      );
    }

    final paths = result!.outputPaths ??
        (result!.outputPath != null ? [result!.outputPath!] : []);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      color: Colors.green.shade50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Done!',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
          const SizedBox(height: 4),
          ...paths.map((p) => Text(p.split('/').last,
              style: const TextStyle(fontSize: 12))),
          const SizedBox(height: 8),
          Row(
            children: [
              if (paths.isNotEmpty)
                TextButton.icon(
                  icon: const Icon(Icons.open_in_new, size: 16),
                  label: const Text('Open'),
                  onPressed: () => OpenFilex.open(paths.first),
                ),
              if (paths.isNotEmpty)
                TextButton.icon(
                  icon: const Icon(Icons.share, size: 16),
                  label: const Text('Share'),
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
  final String label;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  const FileTile({
    super.key,
    required this.path,
    required this.label,
    required this.onTap,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(path?.split('/').last ?? label,
          style: TextStyle(
              color: path == null ? Colors.grey : Colors.black,
              fontSize: 13)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(onPressed: onTap, child: const Text('Select')),
          if (path != null && onClear != null)
            IconButton(
                icon: const Icon(Icons.close, size: 16),
                onPressed: onClear),
        ],
      ),
    );
  }
}
