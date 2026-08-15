import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdfx/pdfx.dart' as pdfx;
import 'package:syncfusion_flutter_pdf/pdf.dart' as spdf;
import '../../../../core/utils/file_utils.dart';

abstract class ConversionDataSource {
  Future<List<String>> pdfToImages(String path);
  Future<String> imagesToPdf(List<String> imagePaths);
  Future<String> pdfToWord(String path);
  Future<String> pdfToExcel(String path);
  Future<String> pdfToPpt(String path);
  Future<String> htmlToPdf(String htmlContent);
}

class ConversionDataSourceImpl implements ConversionDataSource {
  @override
  Future<List<String>> pdfToImages(String path) async {
    final document = await pdfx.PdfDocument.openFile(path);
    final outputPaths = <String>[];

    for (int i = 1; i <= document.pagesCount; i++) {
      final page = await document.getPage(i);
      final image = await page.render(
        width: page.width * 2,
        height: page.height * 2,
        format: pdfx.PdfPageImageFormat.jpeg,
      );
      await page.close();

      final imagePath = await FileUtils.getOutputPath('page_$i', extension: 'jpg');
      await File(imagePath).writeAsBytes(image!.bytes);
      outputPaths.add(imagePath);
    }

    await document.close();
    return outputPaths;
  }

  @override
  Future<String> imagesToPdf(List<String> imagePaths) async {
    final doc = pw.Document();

    for (final imagePath in imagePaths) {
      final imageBytes = await File(imagePath).readAsBytes();
      final image = pw.MemoryImage(imageBytes);
      doc.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (context) =>
              pw.Center(child: pw.Image(image, fit: pw.BoxFit.contain)),
        ),
      );
    }

    final bytes = await doc.save();
    final outputPath = await FileUtils.getOutputPath('images_to_pdf');
    await File(outputPath).writeAsBytes(bytes);
    return outputPath;
  }

  @override
  Future<String> pdfToWord(String path) async {
    final text = await _extractText(path);
    final outputPath =
        await FileUtils.getOutputPath('pdf_to_word', extension: 'docx');
    await _writeDocx(outputPath, text);
    return outputPath;
  }

  @override
  Future<String> pdfToExcel(String path) async {
    final text = await _extractText(path);
    final outputPath =
        await FileUtils.getOutputPath('pdf_to_excel', extension: 'xlsx');
    await _writeXlsx(outputPath, text);
    return outputPath;
  }

  @override
  Future<String> pdfToPpt(String path) async {
    final text = await _extractText(path);
    final outputPath =
        await FileUtils.getOutputPath('pdf_to_ppt', extension: 'pptx');
    await _writePptx(outputPath, text);
    return outputPath;
  }

  @override
  Future<String> htmlToPdf(String htmlContent) async {
    final doc = pw.Document();
    final plainText = htmlContent.replaceAll(RegExp(r'<[^>]*>'), ' ').trim();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) => [
          pw.Text(plainText,
              style: const pw.TextStyle(fontSize: 11),
              textAlign: pw.TextAlign.justify),
        ],
      ),
    );

    final bytes = await doc.save();
    final outputPath = await FileUtils.getOutputPath('html_to_pdf');
    await File(outputPath).writeAsBytes(bytes);
    return outputPath;
  }

  Future<String> _extractText(String path) async {
    final bytes = await File(path).readAsBytes();
    final doc = spdf.PdfDocument(inputBytes: bytes);
    final text = spdf.PdfTextExtractor(doc).extractText();
    doc.dispose();
    return text;
  }

  Future<void> _writeDocx(String outputPath, String text) async {
    final archive = Archive();

    final paragraphs = text
        .split('\n')
        .map((p) =>
            '<w:p><w:r><w:t xml:space="preserve">${FileUtils.xmlEscape(p)}</w:t></w:r></w:p>')
        .join('\n');

    _addFile(archive, '[Content_Types].xml', '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
  <Default Extension="xml" ContentType="application/xml"/>
  <Override PartName="/word/document.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/>
</Types>''');

    _addFile(archive, '_rels/.rels', '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="word/document.xml"/>
</Relationships>''');

    _addFile(archive, 'word/document.xml', '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
  <w:body>$paragraphs</w:body>
</w:document>''');

    _addFile(archive, 'word/_rels/document.xml.rels', '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"/>''');

    await File(outputPath).writeAsBytes(ZipEncoder().encode(archive)!);
  }

  Future<void> _writeXlsx(String outputPath, String text) async {
    final archive = Archive();
    final lines = text.split('\n');

    _addFile(archive, '[Content_Types].xml', '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
  <Default Extension="xml" ContentType="application/xml"/>
  <Override PartName="/xl/workbook.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/>
  <Override PartName="/xl/worksheets/sheet1.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>
</Types>''');

    _addFile(archive, '_rels/.rels', '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="xl/workbook.xml"/>
</Relationships>''');

    _addFile(archive, 'xl/workbook.xml', '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<workbook xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main"
          xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">
  <sheets><sheet name="PDF Content" sheetId="1" r:id="rId1"/></sheets>
</workbook>''');

    _addFile(archive, 'xl/_rels/workbook.xml.rels', '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet1.xml"/>
</Relationships>''');

    final rows = lines
        .asMap()
        .entries
        .map((e) =>
            '<row r="${e.key + 1}"><c r="A${e.key + 1}" t="inlineStr"><is><t>${FileUtils.xmlEscape(e.value)}</t></is></c></row>')
        .join('\n');

    _addFile(archive, 'xl/worksheets/sheet1.xml', '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">
  <sheetData>$rows</sheetData>
</worksheet>''');

    await File(outputPath).writeAsBytes(ZipEncoder().encode(archive)!);
  }

  Future<void> _writePptx(String outputPath, String text) async {
    final archive = Archive();
    final paragraphs =
        text.split('\n\n').where((p) => p.trim().isNotEmpty).toList();
    final count = paragraphs.isEmpty ? 1 : paragraphs.length;

    final overrides = List.generate(count,
        (i) => '  <Override PartName="/ppt/slides/slide${i + 1}.xml" ContentType="application/vnd.openxmlformats-officedocument.presentationml.slide+xml"/>').join('\n');

    _addFile(archive, '[Content_Types].xml', '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
  <Default Extension="xml" ContentType="application/xml"/>
  <Override PartName="/ppt/presentation.xml" ContentType="application/vnd.openxmlformats-officedocument.presentationml.presentation.main+xml"/>
$overrides
</Types>''');

    _addFile(archive, '_rels/.rels', '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="ppt/presentation.xml"/>
</Relationships>''');

    final slideIds = List.generate(count,
        (i) => '    <p:sldId id="${256 + i}" r:id="rId${i + 1}"/>').join('\n');

    _addFile(archive, 'ppt/presentation.xml', '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<p:presentation xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main"
                xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"
                xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">
  <p:sldSz cx="9144000" cy="6858000"/>
  <p:notesSz cx="6858000" cy="9144000"/>
  <p:sldIdLst>
$slideIds
  </p:sldIdLst>
</p:presentation>''');

    final presRels = List.generate(count,
        (i) => '  <Relationship Id="rId${i + 1}" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slide" Target="slides/slide${i + 1}.xml"/>').join('\n');

    _addFile(archive, 'ppt/_rels/presentation.xml.rels', '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
$presRels
</Relationships>''');

    final slideContents = paragraphs.isEmpty ? [''] : paragraphs;
    for (int i = 0; i < slideContents.length; i++) {
      final content = FileUtils.xmlEscape(slideContents[i].trim());
      _addFile(archive, 'ppt/slides/slide${i + 1}.xml', '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<p:sld xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main"
       xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"
       xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">
  <p:cSld><p:spTree>
    <p:nvGrpSpPr><p:cNvPr id="1" name=""/><p:cNvGrpSpPr/><p:nvPr/></p:nvGrpSpPr>
    <p:grpSpPr/>
    <p:sp>
      <p:nvSpPr>
        <p:cNvPr id="2" name="Content"/>
        <p:cNvSpPr><a:spLocks noGrp="1"/></p:cNvSpPr>
        <p:nvPr><p:ph idx="1"/></p:nvPr>
      </p:nvSpPr>
      <p:spPr><a:xfrm><a:off x="457200" y="457200"/><a:ext cx="8229600" cy="5943600"/></a:xfrm></p:spPr>
      <p:txBody><a:bodyPr/><a:lstStyle/>
        <a:p><a:r><a:t>$content</a:t></a:r></a:p>
      </p:txBody>
    </p:sp>
  </p:spTree></p:cSld>
</p:sld>''');

      _addFile(archive, 'ppt/slides/_rels/slide${i + 1}.xml.rels', '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"/>''');
    }

    await File(outputPath).writeAsBytes(ZipEncoder().encode(archive)!);
  }

  void _addFile(Archive archive, String name, String content) {
    final bytes = utf8.encode(content);
    archive.addFile(ArchiveFile(name, bytes.length, bytes));
  }
}
