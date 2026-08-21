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
/// en el color de la categoría con acción clara de siguiente paso
/// (abrir / compartir), o error legible. Registra automáticamente el
/// archivo resultante en Recientes la primera vez que [result] pasa a
/// éxito, así ninguna pantalla de herramienta necesita cablear ese
/// seguimiento a mano.
class ResultCard extends StatefulWidget {
  final OperationResult? result;
  final bool isLoading;

  const ResultCard({super.key, this.result, this.isLoading = false});

  @override
  State<ResultCard> createState() => _ResultCardState();
}

class _ResultCardState extends State<ResultCard> {
  OperationResult? _recordedFor;

  /// Ruta tras un renombrado manual desde esta tarjeta — reemplaza la
  /// ruta original de [widget.result] hasta que llegue un resultado
  /// nuevo (otra corrida de la operación).
  String? _renamedPath;

  bool _renaming = false;
  final _renameCtrl = TextEditingController();
  final _renameFocus = FocusNode();
  final _cardKey = GlobalKey();

  @override
  void didUpdateWidget(covariant ResultCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.result != widget.result) {
      _renamedPath = null;
      _renaming = false;
    }
    _maybeRecord();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeRecord());
  }

  @override
  void dispose() {
    _renameCtrl.dispose();
    _renameFocus.dispose();
    super.dispose();
  }

  void _startRename(String currentPath) {
    final currentName = currentPath.split(RegExp(r'[\\/]')).last;
    final dot = currentName.lastIndexOf('.');
    _renameCtrl.text = dot > 0 ? currentName.substring(0, dot) : currentName;
    setState(() => _renaming = true);
    // El teclado puede tapar los botones Guardar/Cancelar si la tarjeta
    // queda cerca del final de la lista — la desplazamos a la vista una
    // vez que el teclado terminó de abrirse.
    Future.delayed(const Duration(milliseconds: 320), () {
      final ctx = _cardKey.currentContext;
      if (ctx == null || !mounted) return;
      // ctx viene fresco de currentContext justo aquí, no es uno capturado
      // antes del await — el guard de mounted arriba ya lo cubre.
      Scrollable.ensureVisible(
        // ignore: use_build_context_synchronously
        ctx,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        alignment: 0.5,
      );
    });
  }

  Future<void> _confirmRename(BuildContext context, String currentPath) async {
    final messenger = ScaffoldMessenger.maybeOf(context);
    final newBase = _renameCtrl.text.trim();
    messenger?.showSnackBar(
      SnackBar(
        content: Text('Guardando como "$newBase"...'),
        duration: const Duration(seconds: 2),
      ),
    );
    if (newBase.isEmpty) {
      if (mounted) setState(() => _renaming = false);
      return;
    }
    try {
      final newPath = await FileUtils.renameOutputFile(currentPath, newBase);
      if (!mounted) return;
      setState(() {
        _renamedPath = newPath;
        _renaming = false;
      });
      if (context.mounted) {
        final controller = context.read<RecentFilesController>();
        controller.remove(currentPath);
        controller.record(newPath);
      }
      messenger?.showSnackBar(SnackBar(content: Text('Renombrado: $newPath')));
    } catch (e, st) {
      debugPrint('Rename: FALLÓ -> $e\n$st');
      if (mounted) setState(() => _renaming = false);
      messenger?.showSnackBar(
        SnackBar(content: Text('Error al renombrar: $e')),
      );
    }
  }

  void _maybeRecord() {
    final result = widget.result;
    if (result == null || !result.isSuccess || result == _recordedFor) return;
    final paths =
        result.outputPaths ??
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
      return Container(
        key: const ValueKey('loading'),
        padding: const EdgeInsets.all(16),
        decoration: AppTheme.card(radius: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2.6, color: accent),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    t.processing,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      minHeight: 4,
                      color: accent,
                      backgroundColor: AppColors.surfaceAlt,
                    ),
                  ),
                ],
              ),
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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.red.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.red.withValues(alpha: 0.3)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.red,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.priority_high_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                t.errorMessage(result.error ?? ''),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final rawPaths =
        result.outputPaths ??
        (result.outputPath != null ? [result.outputPath!] : <String>[]);
    // El renombrado solo se ofrece cuando la operación produjo un único
    // archivo — con varios (p. ej. Dividir PDF) no hay uno solo al que
    // aplicarlo sin ambigüedad.
    final canRename = rawPaths.length == 1;
    final paths = (canRename && _renamedPath != null)
        ? [_renamedPath!]
        : rawPaths;
    final name = paths.isNotEmpty
        ? paths.first.split(RegExp(r'[\\/]')).last
        : '';
    int sizeBytes = 0;
    if (paths.isNotEmpty) {
      try {
        sizeBytes = File(paths.first).lengthSync();
      } catch (_) {}
    }

    return Container(
      key: const ValueKey('success'),
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.colorCard(accent, radius: 18),
      child: Column(
        key: _cardKey,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 380),
                curve: Curves.elasticOut,
                builder: (context, v, child) =>
                    Transform.scale(scale: v, child: child),
                child: const BlackBadge(
                  icon: Icons.check_rounded,
                  size: 36,
                  iconSize: 19,
                ),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  t.done,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.cardText,
                    fontSize: 19,
                  ),
                ),
              ),
            ],
          ),
          if (name.isNotEmpty) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.picture_as_pdf_outlined,
                    size: 17,
                    color: AppColors.cardText,
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: canRename && _renaming
                        ? TextField(
                            controller: _renameCtrl,
                            focusNode: _renameFocus,
                            autofocus: true,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: AppColors.cardText,
                                  fontWeight: FontWeight.w700,
                                ),
                            cursorColor: AppColors.cardText,
                            decoration: const InputDecoration(
                              isDense: true,
                              filled: false,
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                            onSubmitted: (_) =>
                                _confirmRename(context, paths.first),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: AppColors.cardText,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                              if (sizeBytes > 0)
                                Text(
                                  FileUtils.formatFileSize(sizeBytes),
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: AppColors.cardText.withValues(
                                          alpha: 0.65,
                                        ),
                                      ),
                                ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
            ...paths
                .skip(1)
                .map(
                  (p) => Padding(
                    padding: const EdgeInsets.only(top: 6, left: 4),
                    child: Text(
                      p.split(RegExp(r'[\\/]')).last,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.cardText.withValues(alpha: 0.65),
                      ),
                    ),
                  ),
                ),
          ],
          if (paths.isNotEmpty) ...[
            const SizedBox(height: 14),
            if (canRename && _renaming)
              Row(
                children: [
                  Expanded(
                    child: _GlossPillButton(
                      label: t.cancel,
                      background: AppColors.badge,
                      foreground: Colors.white,
                      onTap: () {
                        _renameFocus.unfocus();
                        setState(() => _renaming = false);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _GlossPillButton(
                      label: t.save,
                      background: AppColors.red,
                      foreground: Colors.white,
                      onTap: () {
                        _renameFocus.unfocus();
                        _confirmRename(context, paths.first);
                      },
                    ),
                  ),
                ],
              )
            else
              Row(
                children: [
                  Expanded(
                    child: _GlossPillButton(
                      label: t.open,
                      background: AppColors.badge,
                      foreground: Colors.white,
                      onTap: () => OpenFilex.open(paths.first),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _GlossPillButton(
                      label: t.share,
                      background: AppColors.red,
                      foreground: Colors.white,
                      onTap: () => Share.shareXFiles(
                        paths.map((p) => XFile(p)).toList(),
                      ),
                    ),
                  ),
                  if (canRename) ...[
                    const SizedBox(width: 10),
                    Expanded(
                      child: _GlossPillButton(
                        label: t.renameShort,
                        background: accent,
                        foreground: AppColors.cardText,
                        onTap: () => _startRename(paths.first),
                      ),
                    ),
                  ],
                ],
              ),
          ],
        ],
      ),
    );
  }
}

class _GlossPillButton extends StatelessWidget {
  final String label;
  final Color background;
  final Color foreground;
  final VoidCallback onTap;

  const _GlossPillButton({
    required this.label,
    required this.background,
    required this.foreground,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: foreground,
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

/// Selector de archivo grande y claro — nunca solo un ícono. Estado
/// vacío: tap directo al picker nativo, borde en el color de categoría.
/// Estado con archivo: tarjeta plana en el color de categoría con
/// insignia negra, nombre + tamaño, "Cambiar" como píldora negra.
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
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: accent, width: 1.6),
          ),
          child: Column(
            children: [
              Icon(Icons.upload_file_outlined, color: accent, size: 26),
              const SizedBox(height: 8),
              Text(
                label ?? t.selectFileCta,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: accent),
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
      decoration: AppTheme.colorCard(accent, radius: 18),
      child: Row(
        children: [
          const BlackBadge(
            icon: Icons.picture_as_pdf_outlined,
            size: 40,
            iconSize: 18,
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
                    fontWeight: FontWeight.w700,
                    color: AppColors.cardText,
                  ),
                ),
                Text(
                  FileUtils.formatFileSize(sizeBytes),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.cardText.withValues(alpha: 0.65),
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: AppColors.badge,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                t.changeFile,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 11.5,
                ),
              ),
            ),
          ),
          if (onClear != null)
            IconButton(
              icon: Icon(
                Icons.close,
                size: 18,
                color: AppColors.cardText.withValues(alpha: 0.6),
              ),
              onPressed: onClear,
            ),
        ],
      ),
    );
  }
}
