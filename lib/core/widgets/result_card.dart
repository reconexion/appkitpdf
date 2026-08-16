import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:share_plus/share_plus.dart';
import '../l10n/app_strings.dart';
import '../result/result.dart';
import '../theme/app_theme.dart';
import 'glass_panel.dart';

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
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: const LinearProgressIndicator(minHeight: 4),
            ),
            const SizedBox(height: 10),
            Text(
              t.processing.toUpperCase(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      );
    }
    if (result == null) return const SizedBox.shrink(key: ValueKey('empty'));

    if (!result!.isSuccess) {
      return Padding(
        key: const ValueKey('error'),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: GlassPanel(
          accent: AppColors.red,
          radius: 14,
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: AppColors.red, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  t.errorMessage(result!.error ?? ''),
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: AppColors.red, height: 1.4),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final paths = result!.outputPaths ??
        (result!.outputPath != null ? [result!.outputPath!] : []);
    final accent = AccentScope.of(context);

    return Padding(
      key: const ValueKey('success'),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GlassPanel(
        accent: accent,
        radius: 16,
        padding: const EdgeInsets.all(16),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 350),
                curve: Curves.elasticOut,
                builder: (context, v, child) =>
                    Transform.scale(scale: v, child: child),
                child: Icon(Icons.check_circle, color: accent, size: 18),
              ),
              const SizedBox(width: 8),
              Text(t.done.toUpperCase(), style: Theme.of(context).textTheme.labelLarge),
            ],
          ),
          const SizedBox(height: 10),
          ...paths.map((p) => Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Text(
              p.split('/').last,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.4),
            ),
          )),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (paths.isNotEmpty)
                _ActionButton(
                  icon: Icons.open_in_new,
                  label: t.open,
                  onPressed: () => OpenFilex.open(paths.first),
                ),
              if (paths.isNotEmpty) const SizedBox(width: 10),
              if (paths.isNotEmpty)
                _ActionButton(
                  icon: Icons.ios_share,
                  label: t.share,
                  onPressed: () =>
                      Share.shareXFiles(paths.map((p) => XFile(p)).toList()),
                ),
            ],
          ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _ActionButton(
      {required this.icon, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final accent = AccentScope.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.lerp(Colors.black, accent, 0.22)!, Colors.black],
          ),
          border: Border.fromBorderSide(BorderSide(color: accent)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: accent),
            const SizedBox(width: 6),
            Text(label.toUpperCase(), style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
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
    final accent = AccentScope.of(context);
    final accentSoft = Color.lerp(accent, Colors.white, 0.3)!;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color.lerp(Colors.black, accent, 0.16)!, Colors.black],
        ),
        border: Border.fromBorderSide(BorderSide(color: accent)),
      ),
      child: ListTile(
        dense: true,
        contentPadding: EdgeInsets.zero,
        leading: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Icon(
            selected ? Icons.picture_as_pdf_outlined : Icons.upload_file,
            key: ValueKey(selected),
            size: 18,
            color: accent,
          ),
        ),
        title: Text(
          path?.split('/').last ?? label ?? t.noFileSelected,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: selected ? accent : accentSoft,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: onTap,
              child: Text(
                t.select.toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: accent, fontWeight: FontWeight.w700),
              ),
            ),
            if (selected && onClear != null)
              IconButton(
                icon: Icon(Icons.close, size: 16, color: accent),
                onPressed: onClear,
              ),
          ],
        ),
      ),
    );
  }
}