import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/l10n/app_strings.dart';
import '../../../../core/widgets/result_card.dart';
import '../viewmodels/extras_view_model.dart';

class ExtrasPage extends StatelessWidget {
  const ExtrasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.t.extrasPageTitle)),
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
    final t = context.t;
    return _Section(
      title: t.ocrTitle,
      children: [
        Text(t.ocrDesc,
            style: const TextStyle(fontSize: 12, color: Colors.grey)),
        FileTile(
          path: vm.ocrFile,
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
          child: Text(t.runOcrButton),
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
    final t = context.t;
    return _Section(
      title: t.compareTitle,
      children: [
        Text(t.compareDesc,
            style: const TextStyle(fontSize: 12, color: Colors.grey)),
        FileTile(
          path: vm.compareFile1,
          label: t.pdf1Label,
          onTap: () async {
            final r = await FilePicker.platform.pickFiles(
                type: FileType.custom, allowedExtensions: ['pdf']);
            if (r != null) vm.compareFile1 = r.files.single.path;
          },
          onClear: () => vm.compareFile1 = null,
        ),
        FileTile(
          path: vm.compareFile2,
          label: t.pdf2Label,
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
          child: Text(t.compareButton),
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
    final t = context.t;
    return _Section(
      title: t.repairTitle,
      children: [
        Text(t.repairDesc,
            style: const TextStyle(fontSize: 12, color: Colors.grey)),
        FileTile(
          path: vm.repairFile,
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
          child: Text(t.repairButton),
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
