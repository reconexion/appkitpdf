import 'package:flutter/material.dart';
import '../l10n/app_strings.dart';
import '../theme/app_theme.dart';
import 'pdf_thumbnails.dart';

/// Grid of page thumbnails where the user taps to toggle selection.
/// Reused for Remove / Extract / Rotate / Split "current part" pickers.
/// Selection always renders in red — red is reserved app-wide for
/// active/selected state, never the category accent.
class PdfPageMultiSelect extends StatelessWidget {
  final String path;
  final Set<int> selected;
  final ValueChanged<Set<int>> onChanged;
  final Color? selectedColor;

  /// Optional degrees (0/90/180/270) to preview-rotate a page's thumbnail,
  /// used by the Rotate section.
  final int Function(int pageNumber)? previewRotationOf;

  /// Optional header built once the total page count is known — used for
  /// "select all / clear" shortcuts.
  final Widget Function(int totalPages)? actionsBuilder;

  const PdfPageMultiSelect({
    super.key,
    required this.path,
    required this.selected,
    required this.onChanged,
    this.selectedColor,
    this.previewRotationOf,
    this.actionsBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return PdfThumbnails(
      path: path,
      builder: (context, pages) {
        final color = selectedColor ?? AppColors.red;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (actionsBuilder != null) actionsBuilder!(pages.length),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 0.68,
              ),
              itemCount: pages.length,
              itemBuilder: (context, i) {
                final pageNum = i + 1;
                final isSelected = selected.contains(pageNum);
                final rotation = previewRotationOf?.call(pageNum) ?? 0;
                return GestureDetector(
                  onTap: () {
                    final next = Set<int>.from(selected);
                    isSelected ? next.remove(pageNum) : next.add(pageNum);
                    onChanged(next);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceAlt,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? color : AppColors.borderStrong,
                        width: isSelected ? 2.5 : 1,
                      ),
                      boxShadow: isSelected
                          ? [BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 4)]
                          : [
                              BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.35),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4))
                            ],
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: AnimatedRotation(
                              turns: rotation / 360,
                              duration: const Duration(milliseconds: 200),
                              child: Image.memory(pages[i], fit: BoxFit.cover),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 4,
                          bottom: 4,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 1),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text('$pageNum',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 10)),
                          ),
                        ),
                        if (isSelected)
                          Positioned(
                            right: 4,
                            top: 4,
                            child: CircleAvatar(
                              radius: 10,
                              backgroundColor: color,
                              child: const Icon(Icons.check,
                                  size: 13, color: Colors.white),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

/// List of page thumbnails the user can long-press and drag to reorder.
/// Owns its own order state, initialized to the natural 1..N order, and
/// reports every change (including the initial one) via [onChanged].
class PdfPageReorderList extends StatefulWidget {
  final String path;
  final ValueChanged<List<int>> onChanged;

  const PdfPageReorderList(
      {super.key, required this.path, required this.onChanged});

  @override
  State<PdfPageReorderList> createState() => _PdfPageReorderListState();
}

class _PdfPageReorderListState extends State<PdfPageReorderList> {
  List<int>? _order;

  @override
  Widget build(BuildContext context) {
    return PdfThumbnails(
      path: widget.path,
      builder: (context, pages) {
        final firstInit = _order == null;
        _order ??= List.generate(pages.length, (i) => i + 1);
        if (firstInit) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) widget.onChanged(_order!);
          });
        }
        return ReorderableListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          buildDefaultDragHandles: false,
          itemCount: _order!.length,
          onReorderItem: (oldIndex, newIndex) {
            setState(() {
              final item = _order!.removeAt(oldIndex);
              _order!.insert(newIndex, item);
            });
            widget.onChanged(_order!);
          },
          itemBuilder: (context, i) {
            final pageNum = _order![i];
            final thumbIndex = pageNum - 1;
            final accent = AccentScope.of(context);
            return Container(
              key: ValueKey('page_$pageNum'),
              margin: const EdgeInsets.symmetric(vertical: 4),
              decoration: AppTheme.card(radius: 12),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: thumbIndex >= 0 && thumbIndex < pages.length
                      ? Image.memory(pages[thumbIndex],
                          width: 40, height: 52, fit: BoxFit.cover)
                      : const SizedBox(width: 40, height: 52),
                ),
                title: Text(context.t.pageLabel(pageNum)),
                trailing: ReorderableDragStartListener(
                  index: i,
                  child: Icon(Icons.drag_handle, color: accent),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

/// Small "seleccionar todo / ninguno" action row for [PdfPageMultiSelect].
class PageSelectAllActions extends StatelessWidget {
  final int totalPages;
  final VoidCallback onSelectAll;
  final VoidCallback onClear;

  const PageSelectAllActions({
    super.key,
    required this.totalPages,
    required this.onSelectAll,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Row(
      children: [
        Text(t.pagesCount(totalPages),
            style: Theme.of(context).textTheme.bodySmall),
        const Spacer(),
        TextButton(onPressed: onSelectAll, child: Text(t.selectAll)),
        TextButton(onPressed: onClear, child: Text(t.clearSelection)),
      ],
    );
  }
}
