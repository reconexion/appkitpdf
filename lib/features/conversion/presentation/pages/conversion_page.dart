import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/l10n/app_strings.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/result_card.dart';
import '../../../../core/widgets/tool_list.dart';
import '../viewmodels/conversion_view_model.dart';

const _accent = AppColors.categoryConversion;

List<ToolItem> conversionTools(BuildContext context) {
  final t = context.t;
  return [
    ToolItem(icon: Icons.image_outlined, title: t.pdfToImagesTitle, page: const _PdfToImagesPage()),
    ToolItem(icon: Icons.picture_as_pdf_outlined, title: t.imagesToPdfTitle, page: const _ImagesToPdfPage()),
    ToolItem(icon: Icons.description_outlined, title: t.pdfToWordTitle, page: const _PdfToWordPage()),
    ToolItem(icon: Icons.table_chart_outlined, title: t.pdfToExcelTitle, page: const _PdfToExcelPage()),
    ToolItem(icon: Icons.slideshow_outlined, title: t.pdfToPptTitle, page: const _PdfToPptPage()),
    ToolItem(icon: Icons.code, title: t.htmlToPdfTitle, page: const _HtmlToPdfPage()),
  ];
}

class _PdfToImagesPage extends StatelessWidget {
  const _PdfToImagesPage();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ConversionViewModel>();
    final t = context.t;
    return OperationScaffold(
      title: t.pdfToImagesTitle,
      accent: _accent,
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
        ElevatedButton(
          onPressed: vm.pdfToImagesFile != null && !vm.isConvertingToImages
              ? () => vm.convertPdfToImages()
              : null,
          child: Text(t.convertToImagesButton),
        ),
        ResultCard(result: vm.pdfToImagesResult, isLoading: vm.isConvertingToImages),
      ],
    );
  }
}

class _ImagesToPdfPage extends StatelessWidget {
  const _ImagesToPdfPage();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ConversionViewModel>();
    final t = context.t;
    final accent = _accent;
    return OperationScaffold(
      title: t.imagesToPdfTitle,
      accent: _accent,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () async {
            final r = await FilePicker.platform.pickFiles(
              type: FileType.image,
              allowMultiple: true,
            );
            if (r != null) {
              vm.imagesToPdfFiles = r.files.map((f) => f.path!).toList();
            }
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: accent, width: 1.4),
            ),
            child: Column(
              children: [
                Icon(Icons.image_outlined, color: accent, size: 26),
                const SizedBox(height: 8),
                Text(t.selectImagesMultiple,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: accent)),
                if (vm.imagesToPdfFiles.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(t.imagesSelected(vm.imagesToPdfFiles.length),
                      style: Theme.of(context).textTheme.bodySmall),
                ],
              ],
            ),
          ),
        ),
        ElevatedButton(
          onPressed: vm.imagesToPdfFiles.isNotEmpty && !vm.isConvertingToPdf
              ? () => vm.convertImagesToPdf()
              : null,
          child: Text(t.createPdfButton),
        ),
        ResultCard(result: vm.imagesToPdfResult, isLoading: vm.isConvertingToPdf),
      ],
    );
  }
}

class _PdfToWordPage extends StatelessWidget {
  const _PdfToWordPage();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ConversionViewModel>();
    final t = context.t;
    return OperationScaffold(
      title: t.pdfToWordTitle,
      accent: _accent,
      children: [
        Text(t.pdfToWordDesc, style: Theme.of(context).textTheme.bodySmall),
        FileTile(
          path: vm.pdfToWordFile,
          onTap: () async {
            final r = await FilePicker.platform.pickFiles(
                type: FileType.custom, allowedExtensions: ['pdf']);
            if (r != null) vm.pdfToWordFile = r.files.single.path;
          },
          onClear: () => vm.pdfToWordFile = null,
        ),
        ElevatedButton(
          onPressed: vm.pdfToWordFile != null && !vm.isConvertingToWord
              ? () => vm.convertPdfToWord()
              : null,
          child: Text(t.convertToWordButton),
        ),
        ResultCard(result: vm.pdfToWordResult, isLoading: vm.isConvertingToWord),
      ],
    );
  }
}

class _PdfToExcelPage extends StatelessWidget {
  const _PdfToExcelPage();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ConversionViewModel>();
    final t = context.t;
    return OperationScaffold(
      title: t.pdfToExcelTitle,
      accent: _accent,
      children: [
        Text(t.pdfToExcelDesc, style: Theme.of(context).textTheme.bodySmall),
        FileTile(
          path: vm.pdfToExcelFile,
          onTap: () async {
            final r = await FilePicker.platform.pickFiles(
                type: FileType.custom, allowedExtensions: ['pdf']);
            if (r != null) vm.pdfToExcelFile = r.files.single.path;
          },
          onClear: () => vm.pdfToExcelFile = null,
        ),
        ElevatedButton(
          onPressed: vm.pdfToExcelFile != null && !vm.isConvertingToExcel
              ? () => vm.convertPdfToExcel()
              : null,
          child: Text(t.convertToExcelButton),
        ),
        ResultCard(result: vm.pdfToExcelResult, isLoading: vm.isConvertingToExcel),
      ],
    );
  }
}

class _PdfToPptPage extends StatelessWidget {
  const _PdfToPptPage();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ConversionViewModel>();
    final t = context.t;
    return OperationScaffold(
      title: t.pdfToPptTitle,
      accent: _accent,
      children: [
        Text(t.pdfToPptDesc, style: Theme.of(context).textTheme.bodySmall),
        FileTile(
          path: vm.pdfToPptFile,
          onTap: () async {
            final r = await FilePicker.platform.pickFiles(
                type: FileType.custom, allowedExtensions: ['pdf']);
            if (r != null) vm.pdfToPptFile = r.files.single.path;
          },
          onClear: () => vm.pdfToPptFile = null,
        ),
        ElevatedButton(
          onPressed: vm.pdfToPptFile != null && !vm.isConvertingToPpt
              ? () => vm.convertPdfToPpt()
              : null,
          child: Text(t.convertToPptButton),
        ),
        ResultCard(result: vm.pdfToPptResult, isLoading: vm.isConvertingToPpt),
      ],
    );
  }
}

class _HtmlToPdfPage extends StatefulWidget {
  const _HtmlToPdfPage();
  @override
  State<_HtmlToPdfPage> createState() => _HtmlToPdfPageState();
}

class _HtmlToPdfPageState extends State<_HtmlToPdfPage> {
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
    return OperationScaffold(
      title: t.htmlToPdfTitle,
      accent: _accent,
      children: [
        TextField(
          controller: _ctrl,
          maxLines: 6,
          decoration: InputDecoration(labelText: t.htmlToPdfHint),
        ),
        ElevatedButton(
          onPressed: !vm.isConvertingHtml ? () => vm.convertHtmlToPdf(_ctrl.text) : null,
          child: Text(t.convertToPdfButton),
        ),
        ResultCard(result: vm.htmlToPdfResult, isLoading: vm.isConvertingHtml),
      ],
    );
  }
}
