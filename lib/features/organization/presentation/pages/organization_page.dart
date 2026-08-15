import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/file_utils.dart';
import '../../../../core/widgets/pdf_page_picker.dart';
import '../../../../core/widgets/result_card.dart';
import '../viewmodels/organization_view_model.dart';

enum _InputMode { text, visual }

class OrganizationPage extends StatelessWidget {
  const OrganizationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Organization')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: const [
          _MergeSection(),
          Divider(),
          _SplitSection(),
          Divider(),
          _RemovePagesSection(),
          Divider(),
          _ExtractPagesSection(),
          Divider(),
          _ReorderSection(),
          Divider(),
          _RotateSection(),
        ],
      ),
    );
  }
}

/// "Texto" / "Visual" segmented switch shared by every section below.
class _ModeToggle extends StatelessWidget {
  final _InputMode mode;
  final ValueChanged<_InputMode> onChanged;

  const _ModeToggle({required this.mode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SegmentedButton<_InputMode>(
        segments: const [
          ButtonSegment(
            value: _InputMode.text,
            icon: Icon(Icons.text_fields, size: 16),
            label: Text('Texto'),
          ),
          ButtonSegment(
            value: _InputMode.visual,
            icon: Icon(Icons.grid_view, size: 16),
            label: Text('Visual'),
          ),
        ],
        selected: {mode},
        showSelectedIcon: false,
        onSelectionChanged: (s) => onChanged(s.first),
        style: const ButtonStyle(
            visualDensity: VisualDensity.compact,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap),
      ),
    );
  }
}

class _VisualHint extends StatelessWidget {
  const _VisualHint();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Icon(Icons.info_outline, size: 16, color: Colors.grey.shade600),
          const SizedBox(width: 6),
          Text('Selecciona un PDF para ver sus hojas',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        ],
      ),
    );
  }
}

class _MergeSection extends StatelessWidget {
  const _MergeSection();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<OrganizationViewModel>();
    return _Section(
      title: 'Merge PDFs',
      children: [
        ElevatedButton(
          onPressed: () async {
            final r = await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: ['pdf'],
              allowMultiple: true,
            );
            if (r != null) {
              vm.mergeFiles = r.files.map((f) => f.path!).toList();
            }
          },
          child: const Text('Select PDFs (multiple)'),
        ),
        if (vm.mergeFiles.isNotEmpty) ...[
          Text('${vm.mergeFiles.length} files selected'),
          ...vm.mergeFiles
              .map((p) => Text('• ${p.split('/').last}',
                  style: const TextStyle(fontSize: 12))),
        ],
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: vm.mergeFiles.length >= 2 && !vm.isMerging
              ? () => vm.merge()
              : null,
          child: const Text('Merge'),
        ),
        ResultCard(result: vm.mergeResult, isLoading: vm.isMerging),
      ],
    );
  }
}

class _SplitSection extends StatefulWidget {
  const _SplitSection();
  @override
  State<_SplitSection> createState() => _SplitSectionState();
}

class _SplitSectionState extends State<_SplitSection> {
  final _rangesController = TextEditingController(text: '1-3,4-6');
  _InputMode _mode = _InputMode.visual;
  final List<List<int>> _visualParts = [];
  Set<int> _visualCurrent = {};

  @override
  void dispose() {
    _rangesController.dispose();
    super.dispose();
  }

  List<List<int>> _parseRanges(String input) {
    final ranges = <List<int>>[];
    for (final part in input.split(',')) {
      final trimmed = part.trim();
      if (trimmed.contains('-')) {
        final bounds = trimmed.split('-');
        if (bounds.length == 2) {
          final start = int.tryParse(bounds[0].trim());
          final end = int.tryParse(bounds[1].trim());
          if (start != null && end != null && start <= end) {
            ranges.add(List.generate(end - start + 1, (i) => start + i));
          }
        }
      } else {
        final page = int.tryParse(trimmed);
        if (page != null) ranges.add([page]);
      }
    }
    return ranges;
  }

  List<List<int>> _computeRanges() {
    if (_mode == _InputMode.text) return _parseRanges(_rangesController.text);
    final parts = List<List<int>>.from(_visualParts);
    if (_visualCurrent.isNotEmpty) {
      parts.add(_visualCurrent.toList()..sort());
    }
    return parts;
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<OrganizationViewModel>();
    final ranges = _computeRanges();
    return _Section(
      title: 'Split PDF',
      children: [
        FileTile(
          path: vm.splitFile,
          label: 'No file selected',
          onTap: () async {
            final r = await FilePicker.platform.pickFiles(
                type: FileType.custom, allowedExtensions: ['pdf']);
            if (r != null) vm.splitFile = r.files.single.path;
          },
          onClear: () => vm.splitFile = null,
        ),
        const SizedBox(height: 8),
        _ModeToggle(mode: _mode, onChanged: (m) => setState(() => _mode = m)),
        const SizedBox(height: 8),
        if (_mode == _InputMode.text)
          TextField(
            controller: _rangesController,
            decoration: const InputDecoration(
              labelText: 'Page ranges (e.g. 1-3,4-6 or 1,2,3)',
              isDense: true,
            ),
          )
        else if (vm.splitFile == null)
          const _VisualHint()
        else ...[
          Text('Toca las hojas de la parte actual y agrégalas:',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          PdfPageMultiSelect(
            path: vm.splitFile!,
            selected: _visualCurrent,
            onChanged: (s) => setState(() => _visualCurrent = s),
            actionsBuilder: (total) => PageSelectAllActions(
              totalPages: total,
              onSelectAll: () => setState(() => _visualCurrent =
                  Set.from(List.generate(total, (i) => i + 1))),
              onClear: () => setState(() => _visualCurrent = {}),
            ),
          ),
          if (_visualParts.isNotEmpty)
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: _visualParts.asMap().entries.map((e) {
                return Chip(
                  label: Text('Parte ${e.key + 1}: ${e.value.join(",")}'),
                  onDeleted: () =>
                      setState(() => _visualParts.removeAt(e.key)),
                );
              }).toList(),
            ),
          const SizedBox(height: 4),
          TextButton.icon(
            onPressed: _visualCurrent.isEmpty
                ? null
                : () => setState(() {
                      _visualParts.add(_visualCurrent.toList()..sort());
                      _visualCurrent = {};
                    }),
            icon: const Icon(Icons.add),
            label: const Text('Agregar como nueva parte'),
          ),
        ],
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: vm.splitFile != null && !vm.isSplitting && ranges.isNotEmpty
              ? () => vm.split(ranges)
              : null,
          child: const Text('Split'),
        ),
        ResultCard(result: vm.splitResult, isLoading: vm.isSplitting),
        if (vm.splitResult?.isSuccess == true &&
            vm.splitResult!.outputPaths != null)
          ...vm.splitResult!.outputPaths!.asMap().entries.map(
              (e) => Text('Part ${e.key + 1}: ${e.value.split('/').last}',
                  style: const TextStyle(fontSize: 12))),
      ],
    );
  }
}

class _RemovePagesSection extends StatefulWidget {
  const _RemovePagesSection();
  @override
  State<_RemovePagesSection> createState() => _RemovePagesSectionState();
}

class _RemovePagesSectionState extends State<_RemovePagesSection> {
  final _ctrl = TextEditingController(text: '2,4');
  _InputMode _mode = _InputMode.visual;
  Set<int> _visualSelected = {};

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  List<int> _computePages() {
    if (_mode == _InputMode.text) {
      return _ctrl.text
          .split(',')
          .map((s) => int.tryParse(s.trim()))
          .whereType<int>()
          .toList();
    }
    return _visualSelected.toList()..sort();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<OrganizationViewModel>();
    final pages = _computePages();
    return _Section(
      title: 'Remove Pages',
      children: [
        FileTile(
          path: vm.removeFile,
          label: 'No file selected',
          onTap: () async {
            final r = await FilePicker.platform.pickFiles(
                type: FileType.custom, allowedExtensions: ['pdf']);
            if (r != null) vm.removeFile = r.files.single.path;
          },
          onClear: () => vm.removeFile = null,
        ),
        const SizedBox(height: 8),
        _ModeToggle(mode: _mode, onChanged: (m) => setState(() => _mode = m)),
        const SizedBox(height: 8),
        if (_mode == _InputMode.text)
          TextField(
            controller: _ctrl,
            decoration: const InputDecoration(
                labelText: 'Page numbers to remove (e.g. 2,4,7)',
                isDense: true),
          )
        else if (vm.removeFile == null)
          const _VisualHint()
        else
          PdfPageMultiSelect(
            path: vm.removeFile!,
            selected: _visualSelected,
            selectedColor: Colors.red.shade400,
            onChanged: (s) => setState(() => _visualSelected = s),
            actionsBuilder: (total) => PageSelectAllActions(
              totalPages: total,
              onSelectAll: () => setState(() => _visualSelected =
                  Set.from(List.generate(total, (i) => i + 1))),
              onClear: () => setState(() => _visualSelected = {}),
            ),
          ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: vm.removeFile != null && !vm.isRemoving && pages.isNotEmpty
              ? () => vm.removePages(pages)
              : null,
          child: const Text('Remove Pages'),
        ),
        ResultCard(result: vm.removeResult, isLoading: vm.isRemoving),
      ],
    );
  }
}

class _ExtractPagesSection extends StatefulWidget {
  const _ExtractPagesSection();
  @override
  State<_ExtractPagesSection> createState() => _ExtractPagesSectionState();
}

class _ExtractPagesSectionState extends State<_ExtractPagesSection> {
  final _ctrl = TextEditingController(text: '1,3,5');
  _InputMode _mode = _InputMode.visual;
  Set<int> _visualSelected = {};

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  List<int> _computePages() {
    if (_mode == _InputMode.text) {
      return _ctrl.text
          .split(',')
          .map((s) => int.tryParse(s.trim()))
          .whereType<int>()
          .toList();
    }
    return _visualSelected.toList()..sort();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<OrganizationViewModel>();
    final pages = _computePages();
    return _Section(
      title: 'Extract Pages',
      children: [
        FileTile(
          path: vm.extractFile,
          label: 'No file selected',
          onTap: () async {
            final r = await FilePicker.platform.pickFiles(
                type: FileType.custom, allowedExtensions: ['pdf']);
            if (r != null) vm.extractFile = r.files.single.path;
          },
          onClear: () => vm.extractFile = null,
        ),
        const SizedBox(height: 8),
        _ModeToggle(mode: _mode, onChanged: (m) => setState(() => _mode = m)),
        const SizedBox(height: 8),
        if (_mode == _InputMode.text)
          TextField(
            controller: _ctrl,
            decoration: const InputDecoration(
                labelText: 'Pages to extract (e.g. 1,3,5)', isDense: true),
          )
        else if (vm.extractFile == null)
          const _VisualHint()
        else
          PdfPageMultiSelect(
            path: vm.extractFile!,
            selected: _visualSelected,
            selectedColor: Colors.green.shade600,
            onChanged: (s) => setState(() => _visualSelected = s),
            actionsBuilder: (total) => PageSelectAllActions(
              totalPages: total,
              onSelectAll: () => setState(() => _visualSelected =
                  Set.from(List.generate(total, (i) => i + 1))),
              onClear: () => setState(() => _visualSelected = {}),
            ),
          ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed:
              vm.extractFile != null && !vm.isExtracting && pages.isNotEmpty
                  ? () => vm.extractPages(pages)
                  : null,
          child: const Text('Extract Pages'),
        ),
        ResultCard(result: vm.extractResult, isLoading: vm.isExtracting),
      ],
    );
  }
}

class _ReorderSection extends StatefulWidget {
  const _ReorderSection();
  @override
  State<_ReorderSection> createState() => _ReorderSectionState();
}

class _ReorderSectionState extends State<_ReorderSection> {
  final _ctrl = TextEditingController(text: '3,1,2');
  _InputMode _mode = _InputMode.visual;
  List<int>? _visualOrder;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  List<int> _computeOrder() {
    if (_mode == _InputMode.text) {
      return _ctrl.text
          .split(',')
          .map((s) => int.tryParse(s.trim()))
          .whereType<int>()
          .toList();
    }
    return _visualOrder ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<OrganizationViewModel>();
    final order = _computeOrder();
    return _Section(
      title: 'Reorder Pages',
      children: [
        FileTile(
          path: vm.reorderFile,
          label: 'No file selected',
          onTap: () async {
            final r = await FilePicker.platform.pickFiles(
                type: FileType.custom, allowedExtensions: ['pdf']);
            if (r != null) {
              setState(() => _visualOrder = null);
              vm.reorderFile = r.files.single.path;
            }
          },
          onClear: () {
            setState(() => _visualOrder = null);
            vm.reorderFile = null;
          },
        ),
        const SizedBox(height: 8),
        _ModeToggle(mode: _mode, onChanged: (m) => setState(() => _mode = m)),
        const SizedBox(height: 8),
        if (_mode == _InputMode.text)
          TextField(
            controller: _ctrl,
            decoration: const InputDecoration(
                labelText: 'New order (e.g. 3,1,2 moves page 3 first)',
                isDense: true),
          )
        else if (vm.reorderFile == null)
          const _VisualHint()
        else ...[
          Text('Mantén presionada una hoja y arrástrala para reordenar:',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          PdfPageReorderList(
            path: vm.reorderFile!,
            onChanged: (o) => setState(() => _visualOrder = o),
          ),
        ],
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed:
              vm.reorderFile != null && !vm.isReordering && order.isNotEmpty
                  ? () => vm.reorderPages(order)
                  : null,
          child: const Text('Reorder'),
        ),
        ResultCard(result: vm.reorderResult, isLoading: vm.isReordering),
      ],
    );
  }
}

class _RotateSection extends StatefulWidget {
  const _RotateSection();
  @override
  State<_RotateSection> createState() => _RotateSectionState();
}

class _RotateSectionState extends State<_RotateSection> {
  final _pagesCtrl = TextEditingController(text: '1,2');
  int _degrees = 90;
  _InputMode _mode = _InputMode.visual;
  Set<int> _visualSelected = {};

  @override
  void dispose() {
    _pagesCtrl.dispose();
    super.dispose();
  }

  /// null means "all pages" (only reachable from text mode's empty field).
  List<int>? _computePages() {
    if (_mode == _InputMode.text) {
      final t = _pagesCtrl.text.trim();
      if (t.isEmpty) return null;
      return t
          .split(',')
          .map((s) => int.tryParse(s.trim()))
          .whereType<int>()
          .toList();
    }
    return _visualSelected.isEmpty ? null : (_visualSelected.toList()..sort());
  }

  Future<void> _rotate(OrganizationViewModel vm) async {
    final pages = _computePages();
    final rotations = <int, int>{};
    if (pages != null) {
      for (final p in pages) {
        rotations[p] = _degrees;
      }
    } else {
      final count = await FileUtils.getPdfPageCount(vm.rotateFile!);
      for (int p = 1; p <= count; p++) {
        rotations[p] = _degrees;
      }
    }
    vm.rotatePages(rotations);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<OrganizationViewModel>();
    final computed = _computePages();
    final canRotate = vm.rotateFile != null &&
        !vm.isRotating &&
        (_mode == _InputMode.text || (computed != null && computed.isNotEmpty));
    return _Section(
      title: 'Rotate Pages',
      children: [
        FileTile(
          path: vm.rotateFile,
          label: 'No file selected',
          onTap: () async {
            final r = await FilePicker.platform.pickFiles(
                type: FileType.custom, allowedExtensions: ['pdf']);
            if (r != null) vm.rotateFile = r.files.single.path;
          },
          onClear: () => vm.rotateFile = null,
        ),
        const SizedBox(height: 8),
        _ModeToggle(mode: _mode, onChanged: (m) => setState(() => _mode = m)),
        const SizedBox(height: 8),
        if (_mode == _InputMode.text)
          TextField(
            controller: _pagesCtrl,
            decoration: const InputDecoration(
                labelText: 'Pages to rotate (e.g. 1,2 or leave empty for all)',
                isDense: true),
          )
        else if (vm.rotateFile == null)
          const _VisualHint()
        else
          PdfPageMultiSelect(
            path: vm.rotateFile!,
            selected: _visualSelected,
            previewRotationOf: (p) =>
                _visualSelected.contains(p) ? _degrees : 0,
            onChanged: (s) => setState(() => _visualSelected = s),
            actionsBuilder: (total) => PageSelectAllActions(
              totalPages: total,
              onSelectAll: () => setState(() => _visualSelected =
                  Set.from(List.generate(total, (i) => i + 1))),
              onClear: () => setState(() => _visualSelected = {}),
            ),
          ),
        DropdownButton<int>(
          value: _degrees,
          items: const [
            DropdownMenuItem(value: 90, child: Text('90°')),
            DropdownMenuItem(value: 180, child: Text('180°')),
            DropdownMenuItem(value: 270, child: Text('270°')),
          ],
          onChanged: (v) => setState(() => _degrees = v!),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: canRotate ? () => _rotate(vm) : null,
          child: const Text('Rotate'),
        ),
        ResultCard(result: vm.rotateResult, isLoading: vm.isRotating),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _Section({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      initiallyExpanded: false,
      childrenPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      children: children,
    );
  }
}
