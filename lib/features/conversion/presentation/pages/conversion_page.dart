import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/l10n/app_strings.dart';
import '../../../../core/widgets/result_card.dart';
import '../viewmodels/conversion_view_model.dart';

class ConversionPage extends StatelessWidget {
  const ConversionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.t.conversionPageTitle)),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: const [
          _PdfToImagesSection(),
          Divider(),
          _ImagesToPdfSection(),
          Divider(),
          _PdfToWordSection(),
          Divider(),
          _PdfToExcelSection(),
          Divider(),
          _PdfToPptSection(),
          Divider(),
          _HtmlToPdfSection(),
        ],
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
    return _Section(
      title: t.pdfToImagesTitle,
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
    return _Section(
      title: t.imagesToPdfTitle,
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
          Text(t.imagesSelected(vm.imagesToPdfFiles.length)),
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
    return _Section(
      title: t.pdfToWordTitle,
      children: [
        Text(t.pdfToWordDesc,
            style: const TextStyle(fontSize: 12, color: Colors.grey)),
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
    return _Section(
      title: t.pdfToExcelTitle,
      children: [
        Text(t.pdfToExcelDesc,
            style: const TextStyle(fontSize: 12, color: Colors.grey)),
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
    return _Section(
      title: t.pdfToPptTitle,
      children: [
        Text(t.pdfToPptDesc,
            style: const TextStyle(fontSize: 12, color: Colors.grey)),
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
    return _Section(
      title: t.htmlToPdfTitle,
      children: [
        TextField(
          controller: _ctrl,
          maxLines: 5,
          decoration: InputDecoration(
              labelText: t.htmlToPdfHint, border: const OutlineInputBorder()),
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

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _Section({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      childrenPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      children: children,
    );
  }
}
