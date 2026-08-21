import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/l10n/app_strings.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/pdf_page_picker.dart';
import '../../../../core/widgets/result_card.dart';
import '../../../../core/widgets/tool_list.dart';
import '../viewmodels/organization_view_model.dart';
import 'rename_page.dart';

/// Herramientas de Organización, listadas en Home bajo su propio acento
/// de categoría (azul petróleo) — nunca como fondo, solo contorno/texto.
List<ToolItem> organizationTools(BuildContext context) {
  final t = context.t;
  return [
    ToolItem(icon: Icons.merge_type, title: t.mergeTitle, page: const _MergePage()),
    ToolItem(icon: Icons.call_split, title: t.splitTitle, page: const _SplitPage()),
    ToolItem(icon: Icons.delete_outline, title: t.removeTitle, page: const _RemovePage()),
    ToolItem(icon: Icons.content_cut, title: t.extractTitle, page: const _ExtractPage()),
    ToolItem(icon: Icons.swap_vert, title: t.reorderTitle, page: const _ReorderPage()),
    ToolItem(icon: Icons.rotate_right, title: t.rotateTitle, page: const _RotatePage()),
    ToolItem(icon: Icons.drive_file_rename_outline, title: t.renameTitle, page: const RenamePage()),
  ];
}

Future<String?> _pickPdf() async {
  final r = await FilePicker.platform
      .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
  return r?.files.single.path;
}

/// Selector de degrees (90°/180°/270°) como chips tocables — control
/// visual y directo, nunca un campo de texto. Rojo = seleccionado.
class _DegreesSelector extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;
  const _DegreesSelector({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final accent = AccentScope.of(context);
    return Row(
      children: [90, 180, 270].map((d) {
        final selected = value == d;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: () => onChanged(d),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: selected ? accent : AppColors.badge,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text('$d°',
                  style: TextStyle(
                    color: selected ? AppColors.cardText : Colors.white70,
                    fontWeight: FontWeight.w700,
                    fontSize: 12.5,
                  )),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _MergePage extends StatelessWidget {
  const _MergePage();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<OrganizationViewModel>();
    final t = context.t;
    return OperationScaffold(
      title: t.mergeTitle,
      accent: AppColors.categoryOrganization,
      children: [
        _MultiFileArea(
          paths: vm.mergeFiles,
          onTap: () async {
            final r = await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: ['pdf'],
              allowMultiple: true,
            );
            if (r != null) vm.mergeFiles = r.files.map((f) => f.path!).toList();
          },
        ),
        ElevatedButton(
          onPressed: vm.mergeFiles.length >= 2 && !vm.isMerging
              ? () => vm.merge()
              : null,
          child: Text(t.mergeButton),
        ),
        ResultCard(result: vm.mergeResult, isLoading: vm.isMerging),
      ],
    );
  }
}

class _SplitPage extends StatefulWidget {
  const _SplitPage();
  @override
  State<_SplitPage> createState() => _SplitPageState();
}

class _SplitPageState extends State<_SplitPage> {
  final List<List<int>> _parts = [];
  Set<int> _current = {};

  List<List<int>> _computeRanges() {
    final parts = List<List<int>>.from(_parts);
    if (_current.isNotEmpty) parts.add(_current.toList()..sort());
    return parts;
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<OrganizationViewModel>();
    final t = context.t;
    final ranges = _computeRanges();
    return OperationScaffold(
      title: t.splitTitle,
      accent: AppColors.categoryOrganization,
      children: [
        FileTile(
          path: vm.splitFile,
          onTap: () async {
            final p = await _pickPdf();
            if (p != null) {
              setState(() {
                _parts.clear();
                _current = {};
              });
              vm.splitFile = p;
            }
          },
          onClear: () => vm.splitFile = null,
        ),
        if (vm.splitFile != null) ...[
          FieldLabel(text: t.visualSplitHint),
          PdfPageMultiSelect(
            path: vm.splitFile!,
            selected: _current,
            onChanged: (s) => setState(() => _current = s),
            actionsBuilder: (total) => PageSelectAllActions(
              totalPages: total,
              onSelectAll: () => setState(
                  () => _current = Set.from(List.generate(total, (i) => i + 1))),
              onClear: () => setState(() => _current = {}),
            ),
          ),
          if (_parts.isNotEmpty)
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: _parts.asMap().entries.map((e) {
                return Chip(
                  label: Text(t.partLabel(e.key + 1, e.value.join(","))),
                  onDeleted: () => setState(() => _parts.removeAt(e.key)),
                );
              }).toList(),
            ),
          OutlinedButton.icon(
            onPressed: _current.isEmpty
                ? null
                : () => setState(() {
                      _parts.add(_current.toList()..sort());
                      _current = {};
                    }),
            icon: const Icon(Icons.add, size: 18),
            label: Text(t.addPartButton),
          ),
        ],
        ElevatedButton(
          onPressed: vm.splitFile != null && !vm.isSplitting && ranges.isNotEmpty
              ? () => vm.split(ranges)
              : null,
          child: Text(t.splitButton),
        ),
        ResultCard(result: vm.splitResult, isLoading: vm.isSplitting),
        if (vm.splitResult?.isSuccess == true && vm.splitResult!.outputPaths != null)
          ...vm.splitResult!.outputPaths!.asMap().entries.map((e) => Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  t.partResultLabel(e.key + 1, e.value.split(RegExp(r'[\\/]')).last),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              )),
      ],
    );
  }
}

class _RemovePage extends StatefulWidget {
  const _RemovePage();
  @override
  State<_RemovePage> createState() => _RemovePageState();
}

class _RemovePageState extends State<_RemovePage> {
  Set<int> _selected = {};

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<OrganizationViewModel>();
    final t = context.t;
    final pages = _selected.toList()..sort();
    return OperationScaffold(
      title: t.removeTitle,
      accent: AppColors.categoryOrganization,
      children: [
        FileTile(
          path: vm.removeFile,
          onTap: () async {
            final p = await _pickPdf();
            if (p != null) {
              setState(() => _selected = {});
              vm.removeFile = p;
            }
          },
          onClear: () => vm.removeFile = null,
        ),
        if (vm.removeFile == null)
          Text(t.visualHint, style: Theme.of(context).textTheme.bodySmall)
        else
          PdfPageMultiSelect(
            path: vm.removeFile!,
            selected: _selected,
            onChanged: (s) => setState(() => _selected = s),
            actionsBuilder: (total) => PageSelectAllActions(
              totalPages: total,
              onSelectAll: () => setState(
                  () => _selected = Set.from(List.generate(total, (i) => i + 1))),
              onClear: () => setState(() => _selected = {}),
            ),
          ),
        ElevatedButton(
          onPressed: vm.removeFile != null && !vm.isRemoving && pages.isNotEmpty
              ? () => vm.removePages(pages)
              : null,
          child: Text(t.removeButton),
        ),
        ResultCard(result: vm.removeResult, isLoading: vm.isRemoving),
      ],
    );
  }
}

class _ExtractPage extends StatefulWidget {
  const _ExtractPage();
  @override
  State<_ExtractPage> createState() => _ExtractPageState();
}

class _ExtractPageState extends State<_ExtractPage> {
  Set<int> _selected = {};

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<OrganizationViewModel>();
    final t = context.t;
    final pages = _selected.toList()..sort();
    return OperationScaffold(
      title: t.extractTitle,
      accent: AppColors.categoryOrganization,
      children: [
        FileTile(
          path: vm.extractFile,
          onTap: () async {
            final p = await _pickPdf();
            if (p != null) {
              setState(() => _selected = {});
              vm.extractFile = p;
            }
          },
          onClear: () => vm.extractFile = null,
        ),
        if (vm.extractFile == null)
          Text(t.visualHint, style: Theme.of(context).textTheme.bodySmall)
        else
          PdfPageMultiSelect(
            path: vm.extractFile!,
            selected: _selected,
            onChanged: (s) => setState(() => _selected = s),
            actionsBuilder: (total) => PageSelectAllActions(
              totalPages: total,
              onSelectAll: () => setState(
                  () => _selected = Set.from(List.generate(total, (i) => i + 1))),
              onClear: () => setState(() => _selected = {}),
            ),
          ),
        ElevatedButton(
          onPressed: vm.extractFile != null && !vm.isExtracting && pages.isNotEmpty
              ? () => vm.extractPages(pages)
              : null,
          child: Text(t.extractButton),
        ),
        ResultCard(result: vm.extractResult, isLoading: vm.isExtracting),
      ],
    );
  }
}

class _ReorderPage extends StatefulWidget {
  const _ReorderPage();
  @override
  State<_ReorderPage> createState() => _ReorderPageState();
}

class _ReorderPageState extends State<_ReorderPage> {
  List<int>? _order;

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<OrganizationViewModel>();
    final t = context.t;
    final order = _order ?? [];
    return OperationScaffold(
      title: t.reorderTitle,
      accent: AppColors.categoryOrganization,
      children: [
        FileTile(
          path: vm.reorderFile,
          onTap: () async {
            final p = await _pickPdf();
            if (p != null) {
              setState(() => _order = null);
              vm.reorderFile = p;
            }
          },
          onClear: () {
            setState(() => _order = null);
            vm.reorderFile = null;
          },
        ),
        if (vm.reorderFile == null)
          Text(t.visualHint, style: Theme.of(context).textTheme.bodySmall)
        else ...[
          FieldLabel(text: t.reorderVisualHint),
          PdfPageReorderList(
            path: vm.reorderFile!,
            onChanged: (o) => setState(() => _order = o),
          ),
        ],
        ElevatedButton(
          onPressed: vm.reorderFile != null && !vm.isReordering && order.isNotEmpty
              ? () => vm.reorderPages(order)
              : null,
          child: Text(t.reorderButton),
        ),
        ResultCard(result: vm.reorderResult, isLoading: vm.isReordering),
      ],
    );
  }
}

class _RotatePage extends StatefulWidget {
  const _RotatePage();
  @override
  State<_RotatePage> createState() => _RotatePageState();
}

class _RotatePageState extends State<_RotatePage> {
  int _degrees = 90;
  Set<int> _selected = {};

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<OrganizationViewModel>();
    final t = context.t;
    final canRotate = vm.rotateFile != null && !vm.isRotating && _selected.isNotEmpty;
    return OperationScaffold(
      title: t.rotateTitle,
      accent: AppColors.categoryOrganization,
      children: [
        FileTile(
          path: vm.rotateFile,
          onTap: () async {
            final p = await _pickPdf();
            if (p != null) {
              setState(() => _selected = {});
              vm.rotateFile = p;
            }
          },
          onClear: () => vm.rotateFile = null,
        ),
        if (vm.rotateFile == null)
          Text(t.visualHint, style: Theme.of(context).textTheme.bodySmall)
        else ...[
          _DegreesSelector(value: _degrees, onChanged: (d) => setState(() => _degrees = d)),
          PdfPageMultiSelect(
            path: vm.rotateFile!,
            selected: _selected,
            previewRotationOf: (p) => _selected.contains(p) ? _degrees : 0,
            onChanged: (s) => setState(() => _selected = s),
            actionsBuilder: (total) => PageSelectAllActions(
              totalPages: total,
              onSelectAll: () => setState(
                  () => _selected = Set.from(List.generate(total, (i) => i + 1))),
              onClear: () => setState(() => _selected = {}),
            ),
          ),
        ],
        ElevatedButton(
          onPressed: canRotate
              ? () => vm.rotatePages({for (final p in _selected) p: _degrees})
              : null,
          child: Text(t.rotateButton),
        ),
        ResultCard(result: vm.rotateResult, isLoading: vm.isRotating),
      ],
    );
  }
}

/// Área de selección de múltiples PDFs (Unir) — mismo lenguaje visual que
/// [FileTile]: borde de categoría cuando está vacía, tarjeta clara con la
/// lista de archivos una vez elegidos.
class _MultiFileArea extends StatelessWidget {
  final List<String> paths;
  final VoidCallback onTap;
  const _MultiFileArea({required this.paths, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final accent = AccentScope.of(context);

    if (paths.isEmpty) {
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
              Text(t.selectPdfsMultiple,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: accent)),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: AppTheme.colorCard(accent, radius: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.filesSelected(paths.length),
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: AppColors.cardText, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          ...paths.map((p) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Container(
                        width: 5,
                        height: 5,
                        decoration:
                            const BoxDecoration(color: AppColors.cardText, shape: BoxShape.circle)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        p.split(RegExp(r'[\\/]')).last,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: AppColors.cardText.withValues(alpha: 0.75)),
                      ),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 4),
          InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(color: AppColors.badge, borderRadius: BorderRadius.circular(999)),
              child: Text(t.changeFile,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 11.5)),
            ),
          ),
        ],
      ),
    );
  }
}
