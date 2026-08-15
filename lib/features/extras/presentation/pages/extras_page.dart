import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/result_card.dart';
import '../viewmodels/extras_view_model.dart';

class ExtrasPage extends StatelessWidget {
  const ExtrasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Extras')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: const [
          _OcrSection(),
          Divider(),
          _CompareSection(),
          Divider(),
          _RepairSection(),
        ],
      ),
    );
  }
}

class _OcrSection extends StatelessWidget {
  const _OcrSection();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ExtrasViewModel>();
    return _Section(
      title: 'OCR — Scanned PDF → Selectable Text',
      children: [
        const Text(
            'Renders each page as image, then runs ML Kit text recognition.',
            style: TextStyle(fontSize: 12, color: Colors.grey)),
        FileTile(
          path: vm.ocrFile,
          label: 'No file selected',
          onTap: () async {
            final r = await FilePicker.platform.pickFiles(
                type: FileType.custom, allowedExtensions: ['pdf']);
            if (r != null) vm.ocrFile = r.files.single.path;
          },
          onClear: () => vm.ocrFile = null,
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed:
              vm.ocrFile != null && !vm.isOcring ? () => vm.ocr() : null,
          child: const Text('Run OCR'),
        ),
        ResultCard(result: vm.ocrResult, isLoading: vm.isOcring),
      ],
    );
  }
}

class _CompareSection extends StatelessWidget {
  const _CompareSection();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ExtrasViewModel>();
    return _Section(
      title: 'Compare PDFs',
      children: [
        const Text('Extracts text from both PDFs and diffs line by line.',
            style: TextStyle(fontSize: 12, color: Colors.grey)),
        FileTile(
          path: vm.compareFile1,
          label: 'PDF 1 — not selected',
          onTap: () async {
            final r = await FilePicker.platform.pickFiles(
                type: FileType.custom, allowedExtensions: ['pdf']);
            if (r != null) vm.compareFile1 = r.files.single.path;
          },
          onClear: () => vm.compareFile1 = null,
        ),
        FileTile(
          path: vm.compareFile2,
          label: 'PDF 2 — not selected',
          onTap: () async {
            final r = await FilePicker.platform.pickFiles(
                type: FileType.custom, allowedExtensions: ['pdf']);
            if (r != null) vm.compareFile2 = r.files.single.path;
          },
          onClear: () => vm.compareFile2 = null,
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: vm.compareFile1 != null &&
                  vm.compareFile2 != null &&
                  !vm.isComparing
              ? () => vm.compare()
              : null,
          child: const Text('Compare'),
        ),
        ResultCard(result: vm.compareResult, isLoading: vm.isComparing),
      ],
    );
  }
}

class _RepairSection extends StatelessWidget {
  const _RepairSection();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ExtrasViewModel>();
    return _Section(
      title: 'Repair Corrupted PDF',
      children: [
        const Text(
            'Attempts to load and re-save the PDF, rebuilding its structure.',
            style: TextStyle(fontSize: 12, color: Colors.grey)),
        FileTile(
          path: vm.repairFile,
          label: 'No file selected',
          onTap: () async {
            final r = await FilePicker.platform.pickFiles(
                type: FileType.custom, allowedExtensions: ['pdf']);
            if (r != null) vm.repairFile = r.files.single.path;
          },
          onClear: () => vm.repairFile = null,
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: vm.repairFile != null && !vm.isRepairing
              ? () => vm.repair()
              : null,
          child: const Text('Repair PDF'),
        ),
        ResultCard(result: vm.repairResult, isLoading: vm.isRepairing),
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
      initiallyExpanded: true,
      childrenPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      children: children,
    );
  }
}
