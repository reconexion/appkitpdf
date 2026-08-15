import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/result_card.dart';
import '../viewmodels/organization_view_model.dart';

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

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<OrganizationViewModel>();
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
        TextField(
          controller: _rangesController,
          decoration: const InputDecoration(
            labelText: 'Page ranges (e.g. 1-3,4-6 or 1,2,3)',
            isDense: true,
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: vm.splitFile != null && !vm.isSplitting
              ? () => vm.split(_parseRanges(_rangesController.text))
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

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<OrganizationViewModel>();
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
        TextField(
          controller: _ctrl,
          decoration: const InputDecoration(
              labelText: 'Page numbers to remove (e.g. 2,4,7)',
              isDense: true),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: vm.removeFile != null && !vm.isRemoving
              ? () {
                  final pages = _ctrl.text
                      .split(',')
                      .map((s) => int.tryParse(s.trim()))
                      .whereType<int>()
                      .toList();
                  vm.removePages(pages);
                }
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

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<OrganizationViewModel>();
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
        TextField(
          controller: _ctrl,
          decoration: const InputDecoration(
              labelText: 'Pages to extract (e.g. 1,3,5)',
              isDense: true),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: vm.extractFile != null && !vm.isExtracting
              ? () {
                  final pages = _ctrl.text
                      .split(',')
                      .map((s) => int.tryParse(s.trim()))
                      .whereType<int>()
                      .toList();
                  vm.extractPages(pages);
                }
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

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<OrganizationViewModel>();
    return _Section(
      title: 'Reorder Pages',
      children: [
        FileTile(
          path: vm.reorderFile,
          label: 'No file selected',
          onTap: () async {
            final r = await FilePicker.platform.pickFiles(
                type: FileType.custom, allowedExtensions: ['pdf']);
            if (r != null) vm.reorderFile = r.files.single.path;
          },
          onClear: () => vm.reorderFile = null,
        ),
        TextField(
          controller: _ctrl,
          decoration: const InputDecoration(
              labelText: 'New order (e.g. 3,1,2 moves page 3 first)',
              isDense: true),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: vm.reorderFile != null && !vm.isReordering
              ? () {
                  final order = _ctrl.text
                      .split(',')
                      .map((s) => int.tryParse(s.trim()))
                      .whereType<int>()
                      .toList();
                  vm.reorderPages(order);
                }
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

  @override
  void dispose() {
    _pagesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<OrganizationViewModel>();
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
        TextField(
          controller: _pagesCtrl,
          decoration: const InputDecoration(
              labelText: 'Pages to rotate (e.g. 1,2 or leave empty for all)',
              isDense: true),
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
          onPressed: vm.rotateFile != null && !vm.isRotating
              ? () {
                  final pages = _pagesCtrl.text.trim().isEmpty
                      ? null
                      : _pagesCtrl.text
                          .split(',')
                          .map((s) => int.tryParse(s.trim()))
                          .whereType<int>()
                          .toList();
                  final rotations = <int, int>{};
                  if (pages != null) {
                    for (final p in pages) {
                      rotations[p] = _degrees;
                    }
                  }
                  vm.rotatePages(rotations);
                }
              : null,
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
