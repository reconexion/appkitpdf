import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/result_card.dart';
import '../viewmodels/conversion_view_model.dart';

class ConversionPage extends StatelessWidget {
  const ConversionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Conversion')),
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
    return _Section(
      title: 'PDF → JPG/Images',
      children: [
        FileTile(
          path: vm.pdfToImagesFile,
          label: 'No file selected',
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
          child: const Text('Convert to Images'),
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
    return _Section(
      title: 'Images → PDF',
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
          child: const Text('Select Images (multiple)'),
        ),
        if (vm.imagesToPdfFiles.isNotEmpty)
          Text('${vm.imagesToPdfFiles.length} images selected'),
        ElevatedButton(
          onPressed: vm.imagesToPdfFiles.isNotEmpty && !vm.isConvertingToPdf
              ? () => vm.convertImagesToPdf()
              : null,
          child: const Text('Create PDF'),
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
    return _Section(
      title: 'PDF → Word (.docx)',
      children: [
        const Text('Extracts text and creates a Word document.',
            style: TextStyle(fontSize: 12, color: Colors.grey)),
        FileTile(
          path: vm.pdfToWordFile,
          label: 'No file selected',
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
          child: const Text('Convert to Word'),
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
    return _Section(
      title: 'PDF → Excel (.xlsx)',
      children: [
        const Text('Extracts text into spreadsheet rows.',
            style: TextStyle(fontSize: 12, color: Colors.grey)),
        FileTile(
          path: vm.pdfToExcelFile,
          label: 'No file selected',
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
          child: const Text('Convert to Excel'),
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
    return _Section(
      title: 'PDF → PowerPoint (.pptx)',
      children: [
        const Text('Each text block becomes a slide.',
            style: TextStyle(fontSize: 12, color: Colors.grey)),
        FileTile(
          path: vm.pdfToPptFile,
          label: 'No file selected',
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
          child: const Text('Convert to PowerPoint'),
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
    return _Section(
      title: 'HTML → PDF',
      children: [
        TextField(
          controller: _ctrl,
          maxLines: 5,
          decoration: const InputDecoration(
              labelText: 'Paste HTML content here', border: OutlineInputBorder()),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: !vm.isConvertingHtml
              ? () => vm.convertHtmlToPdf(_ctrl.text)
              : null,
          child: const Text('Convert to PDF'),
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
