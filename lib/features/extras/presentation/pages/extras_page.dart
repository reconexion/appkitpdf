import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/l10n/app_strings.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/result_card.dart';
import '../../../../core/widgets/tool_list.dart';
import '../viewmodels/extras_view_model.dart';

const _accent = AppColors.categoryExtras;

List<ToolItem> extrasTools(BuildContext context) {
  final t = context.t;
  return [
    ToolItem(icon: Icons.document_scanner_outlined, title: t.ocrTitle, page: const _OcrPage()),
    ToolItem(icon: Icons.compare_arrows, title: t.compareTitle, page: const _ComparePage()),
    ToolItem(icon: Icons.healing_outlined, title: t.repairTitle, page: const _RepairPage()),
  ];
}

class _OcrPage extends StatelessWidget {
  const _OcrPage();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ExtrasViewModel>();
    final t = context.t;
    return OperationScaffold(
      title: t.ocrTitle,
      accent: _accent,
      children: [
        Text(t.ocrDesc, style: Theme.of(context).textTheme.bodySmall),
        FileTile(
          path: vm.ocrFile,
          onTap: () async {
            final r = await FilePicker.platform.pickFiles(
                type: FileType.custom, allowedExtensions: ['pdf']);
            if (r != null) vm.ocrFile = r.files.single.path;
          },
          onClear: () => vm.ocrFile = null,
        ),
        ElevatedButton(
          onPressed: vm.ocrFile != null && !vm.isOcring ? () => vm.ocr() : null,
          child: Text(t.runOcrButton),
        ),
        ResultCard(result: vm.ocrResult, isLoading: vm.isOcring),
      ],
    );
  }
}

class _ComparePage extends StatelessWidget {
  const _ComparePage();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ExtrasViewModel>();
    final t = context.t;
    return OperationScaffold(
      title: t.compareTitle,
      accent: _accent,
      children: [
        Text(t.compareDesc, style: Theme.of(context).textTheme.bodySmall),
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
        ElevatedButton(
          onPressed: vm.compareFile1 != null && vm.compareFile2 != null && !vm.isComparing
              ? () => vm.compare()
              : null,
          child: Text(t.compareButton),
        ),
        ResultCard(result: vm.compareResult, isLoading: vm.isComparing),
      ],
    );
  }
}

class _RepairPage extends StatelessWidget {
  const _RepairPage();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ExtrasViewModel>();
    final t = context.t;
    return OperationScaffold(
      title: t.repairTitle,
      accent: _accent,
      children: [
        Text(t.repairDesc, style: Theme.of(context).textTheme.bodySmall),
        FileTile(
          path: vm.repairFile,
          onTap: () async {
            final r = await FilePicker.platform.pickFiles(
                type: FileType.custom, allowedExtensions: ['pdf']);
            if (r != null) vm.repairFile = r.files.single.path;
          },
          onClear: () => vm.repairFile = null,
        ),
        ElevatedButton(
          onPressed: vm.repairFile != null && !vm.isRepairing ? () => vm.repair() : null,
          child: Text(t.repairButton),
        ),
        ResultCard(result: vm.repairResult, isLoading: vm.isRepairing),
      ],
    );
  }
}
