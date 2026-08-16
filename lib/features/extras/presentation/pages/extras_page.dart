import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/l10n/app_strings.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/feature_grid.dart';
import '../../../../core/widgets/result_card.dart';
import '../../../../core/widgets/terminal_widgets.dart';
import '../viewmodels/extras_view_model.dart';

class ExtrasPage extends StatelessWidget {
  const ExtrasPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return TerminalScaffold(
      tag: 'extras',
      title: t.extrasPageTitle,
      accent: AppColors.accentExtras,
      body: FeatureGrid(
        items: [
          FeatureGridItem(
            icon: Icons.document_scanner_outlined,
            title: t.ocrTitle,
            subtitle: t.ocrHint,
            color: AppColors.operationColor(0),
            page: _OperationPage(
                tag: 'ocr', color: AppColors.operationColor(0), child: const _OcrSection()),
          ),
          FeatureGridItem(
            icon: Icons.compare_arrows,
            title: t.compareTitle,
            subtitle: t.compareHint,
            color: AppColors.operationColor(1),
            page: _OperationPage(
                tag: 'compare', color: AppColors.operationColor(1), child: const _CompareSection()),
          ),
          FeatureGridItem(
            icon: Icons.build_outlined,
            title: t.repairTitle,
            subtitle: t.repairHint,
            color: AppColors.operationColor(2),
            page: _OperationPage(
                tag: 'repair', color: AppColors.operationColor(2), child: const _RepairSection()),
          ),
        ],
      ),
    );
  }
}

/// Wraps a single operation section in its own page, reached from the
/// operation grid above.
class _OperationPage extends StatelessWidget {
  final String tag;
  final Color color;
  final Widget child;
  const _OperationPage({required this.tag, required this.color, required this.child});

  @override
  Widget build(BuildContext context) {
    return TerminalScaffold(
      tag: tag,
      title: context.t.extrasPageTitle,
      accent: color,
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [child],
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
    return TerminalSection(
      title: t.ocrTitle,
      initiallyExpanded: true,
      children: [
        Text(t.ocrDesc, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 8),
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
    return TerminalSection(
      title: t.compareTitle,
      initiallyExpanded: true,
      children: [
        Text(t.compareDesc, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 8),
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
    return TerminalSection(
      title: t.repairTitle,
      initiallyExpanded: true,
      children: [
        Text(t.repairDesc, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 8),
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