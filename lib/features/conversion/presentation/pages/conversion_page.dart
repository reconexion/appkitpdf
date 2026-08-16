import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/l10n/app_strings.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/feature_grid.dart';
import '../../../../core/widgets/result_card.dart';
import '../../../../core/widgets/terminal_widgets.dart';
import '../viewmodels/conversion_view_model.dart';

class ConversionPage extends StatelessWidget {
  const ConversionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return TerminalScaffold(
      tag: 'convert',
      title: t.conversionPageTitle,
      accent: AppColors.accentConversion,
      body: FeatureGrid(
        items: [
          FeatureGridItem(
            icon: Icons.image_outlined,
            title: t.pdfToImagesTitle,
            subtitle: t.pdfToImagesHint,
            color: AppColors.operationColor(0),
            page: _OperationPage(
                tag: 'pdf2img', color: AppColors.operationColor(0), child: const _PdfToImagesSection()),
          ),
          FeatureGridItem(
            icon: Icons.picture_as_pdf_outlined,
            title: t.imagesToPdfTitle,
            subtitle: t.imagesToPdfHint,
            color: AppColors.operationColor(1),
            page: _OperationPage(
                tag: 'img2pdf', color: AppColors.operationColor(1), child: const _ImagesToPdfSection()),
          ),
          FeatureGridItem(
            icon: Icons.description_outlined,
            title: t.pdfToWordTitle,
            subtitle: t.pdfToWordHint,
            color: AppColors.operationColor(2),
            page: _OperationPage(
                tag: 'pdf2word', color: AppColors.operationColor(2), child: const _PdfToWordSection()),
          ),
          FeatureGridItem(
            icon: Icons.table_chart_outlined,
            title: t.pdfToExcelTitle,
            subtitle: t.pdfToExcelHint,
            color: AppColors.operationColor(3),
            page: _OperationPage(
                tag: 'pdf2excel', color: AppColors.operationColor(3), child: const _PdfToExcelSection()),
          ),
          FeatureGridItem(
            icon: Icons.slideshow_outlined,
            title: t.pdfToPptTitle,
            subtitle: t.pdfToPptHint,
            color: AppColors.operationColor(4),
            page: _OperationPage(
                tag: 'pdf2ppt', color: AppColors.operationColor(4), child: const _PdfToPptSection()),
          ),
          FeatureGridItem(
            icon: Icons.code,
            title: t.htmlToPdfTitle,
            subtitle: t.htmlToPdfCardHint,
            color: AppColors.operationColor(5),
            page: _OperationPage(
                tag: 'html2pdf', color: AppColors.operationColor(5), child: const _HtmlToPdfSection()),
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
      title: context.t.conversionPageTitle,
      accent: color,
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [child],
      ),
    );
  }
}

class _PdfToImagesSection extends StatelessWidget {
  const _PdfToImagesSection();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ConversionViewModel>();
    final t = context.t;
    return TerminalSection(
      title: t.pdfToImagesTitle,
      initiallyExpanded: true,
      children: [
        FileTile(
          path: vm.pdfToImagesFile,
          onTap: () async {
            final r = await FilePicker.platform.pickFiles(
                type: FileType.custom, allowedExtensions: ['pdf']);
            if (r != null) vm.pdfToImagesFile = r.files.single.path;
          },
          onClear: () => vm.pdfToImagesFile = null,
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: vm.pdfToImagesFile != null && !vm.isConvertingToImages
              ? () => vm.convertPdfToImages()
              : null,
          child: Text(t.convertToImagesButton),
        ),
        ResultCard(
            result: vm.pdfToImagesResult,
            isLoading: vm.isConvertingToImages),
      ],
    );
  }
}

class _ImagesToPdfSection extends StatelessWidget {
  const _ImagesToPdfSection();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ConversionViewModel>();
    final t = context.t;
    return TerminalSection(
      title: t.imagesToPdfTitle,
      initiallyExpanded: true,
      children: [
        ElevatedButton(
          onPressed: () async {
            final r = await FilePicker.platform.pickFiles(
              type: FileType.image,
              allowMultiple: true,
            );
            if (r != null) {
              vm.imagesToPdfFiles = r.files.map((f) => f.path!).toList();
            }
          },
          child: Text(t.selectImagesMultiple),
        ),
        if (vm.imagesToPdfFiles.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(t.imagesSelected(vm.imagesToPdfFiles.length),
                style: Theme.of(context).textTheme.bodySmall),
          ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: vm.imagesToPdfFiles.isNotEmpty && !vm.isConvertingToPdf
              ? () => vm.convertImagesToPdf()
              : null,
          child: Text(t.createPdfButton),
        ),
        ResultCard(
            result: vm.imagesToPdfResult, isLoading: vm.isConvertingToPdf),
      ],
    );
  }
}

class _PdfToWordSection extends StatelessWidget {
  const _PdfToWordSection();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ConversionViewModel>();
    final t = context.t;
    return TerminalSection(
      title: t.pdfToWordTitle,
      initiallyExpanded: true,
      children: [
        Text(t.pdfToWordDesc, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 8),
        FileTile(
          path: vm.pdfToWordFile,
          onTap: () async {
            final r = await FilePicker.platform.pickFiles(
                type: FileType.custom, allowedExtensions: ['pdf']);
            if (r != null) vm.pdfToWordFile = r.files.single.path;
          },
          onClear: () => vm.pdfToWordFile = null,
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: vm.pdfToWordFile != null && !vm.isConvertingToWord
              ? () => vm.convertPdfToWord()
              : null,
          child: Text(t.convertToWordButton),
        ),
        ResultCard(
            result: vm.pdfToWordResult, isLoading: vm.isConvertingToWord),
      ],
    );
  }
}

class _PdfToExcelSection extends StatelessWidget {
  const _PdfToExcelSection();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ConversionViewModel>();
    final t = context.t;
    return TerminalSection(
      title: t.pdfToExcelTitle,
      initiallyExpanded: true,
      children: [
        Text(t.pdfToExcelDesc, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 8),
        FileTile(
          path: vm.pdfToExcelFile,
          onTap: () async {
            final r = await FilePicker.platform.pickFiles(
                type: FileType.custom, allowedExtensions: ['pdf']);
            if (r != null) vm.pdfToExcelFile = r.files.single.path;
          },
          onClear: () => vm.pdfToExcelFile = null,
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: vm.pdfToExcelFile != null && !vm.isConvertingToExcel
              ? () => vm.convertPdfToExcel()
              : null,
          child: Text(t.convertToExcelButton),
        ),
        ResultCard(
            result: vm.pdfToExcelResult, isLoading: vm.isConvertingToExcel),
      ],
    );
  }
}

class _PdfToPptSection extends StatelessWidget {
  const _PdfToPptSection();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ConversionViewModel>();
    final t = context.t;
    return TerminalSection(
      title: t.pdfToPptTitle,
      initiallyExpanded: true,
      children: [
        Text(t.pdfToPptDesc, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 8),
        FileTile(
          path: vm.pdfToPptFile,
          onTap: () async {
            final r = await FilePicker.platform.pickFiles(
                type: FileType.custom, allowedExtensions: ['pdf']);
            if (r != null) vm.pdfToPptFile = r.files.single.path;
          },
          onClear: () => vm.pdfToPptFile = null,
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: vm.pdfToPptFile != null && !vm.isConvertingToPpt
              ? () => vm.convertPdfToPpt()
              : null,
          child: Text(t.convertToPptButton),
        ),
        ResultCard(
            result: vm.pdfToPptResult, isLoading: vm.isConvertingToPpt),
      ],
    );
  }
}

class _HtmlToPdfSection extends StatefulWidget {
  const _HtmlToPdfSection();
  @override
  State<_HtmlToPdfSection> createState() => _HtmlToPdfSectionState();
}

class _HtmlToPdfSectionState extends State<_HtmlToPdfSection> {
  final _ctrl = TextEditingController(
      text: '<h1>Title</h1><p>Hello World. This is HTML content.</p>');

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ConversionViewModel>();
    final t = context.t;
    return TerminalSection(
      title: t.htmlToPdfTitle,
      initiallyExpanded: true,
      children: [
        TextField(
          controller: _ctrl,
          maxLines: 5,
          decoration: InputDecoration(labelText: t.htmlToPdfHint),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: !vm.isConvertingHtml
              ? () => vm.convertHtmlToPdf(_ctrl.text)
              : null,
          child: Text(t.convertToPdfButton),
        ),
        ResultCard(result: vm.htmlToPdfResult, isLoading: vm.isConvertingHtml),
      ],
    );
  }
}