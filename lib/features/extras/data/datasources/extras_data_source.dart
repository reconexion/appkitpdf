import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart' as pdfx;
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../../../../core/utils/file_utils.dart';

abstract class ExtrasDataSource {
  Future<String> ocrPdf(String path);
  Future<String> comparePdfs(String path1, String path2);
  Future<String> repairPdf(String path);
}

class ExtrasDataSourceImpl implements ExtrasDataSource {
  @override
  Future<String> ocrPdf(String path) async {
    final document = await pdfx.PdfDocument.openFile(path);
    final buffer = StringBuffer();
    final tempDir = await getTemporaryDirectory();
    final textRecognizer =
        TextRecognizer(script: TextRecognitionScript.latin);

    for (int i = 1; i <= document.pagesCount; i++) {
      final page = await document.getPage(i);
      final image = await page.render(
        width: page.width * 2,
        height: page.height * 2,
        format: pdfx.PdfPageImageFormat.jpeg,
      );
      await page.close();

      final imagePath = '${tempDir.path}/ocr_tmp_$i.jpg';
      final imageFile = File(imagePath);
      await imageFile.writeAsBytes(image!.bytes);

      final inputImage = InputImage.fromFilePath(imagePath);
      final recognized = await textRecognizer.processImage(inputImage);
      buffer.writeln('--- Page $i ---');
      buffer.writeln(recognized.text);
      buffer.writeln();

      await FileUtils.deleteSafe(imagePath);
    }

    await document.close();
    await textRecognizer.close();

    final outputPath =
        await FileUtils.getOutputPath('ocr_result', extension: 'txt');
    await File(outputPath).writeAsString(buffer.toString());
    return outputPath;
  }

  @override
  Future<String> comparePdfs(String path1, String path2) async {
    final bytes1 = await File(path1).readAsBytes();
    final bytes2 = await File(path2).readAsBytes();
    final doc1 = PdfDocument(inputBytes: bytes1);
    final doc2 = PdfDocument(inputBytes: bytes2);

    final text1 = PdfTextExtractor(doc1).extractText();
    final text2 = PdfTextExtractor(doc2).extractText();
    final pages1 = doc1.pages.count;
    final pages2 = doc2.pages.count;
    doc1.dispose();
    doc2.dispose();

    final lines1 = text1.split('\n');
    final lines2 = text2.split('\n');
    final maxLines = lines1.length > lines2.length ? lines1.length : lines2.length;

    final report = StringBuffer();
    report.writeln('=== PDF Comparison Report ===');
    report.writeln('PDF 1: ${path1.split('/').last} — $pages1 pages');
    report.writeln('PDF 2: ${path2.split('/').last} — $pages2 pages');
    report.writeln();

    int differences = 0;
    for (int i = 0; i < maxLines; i++) {
      final l1 = i < lines1.length ? lines1[i] : '<missing>';
      final l2 = i < lines2.length ? lines2[i] : '<missing>';
      if (l1 != l2) {
        differences++;
        report.writeln('Line ${i + 1}:');
        report.writeln('  PDF1: $l1');
        report.writeln('  PDF2: $l2');
        report.writeln();
      }
    }
    report.writeln('Total differences: $differences');

    final outputPath =
        await FileUtils.getOutputPath('comparison', extension: 'txt');
    await File(outputPath).writeAsString(report.toString());
    return outputPath;
  }

  @override
  Future<String> repairPdf(String path) async {
    final bytes = await File(path).readAsBytes();

    PdfDocument doc;
    try {
      doc = PdfDocument(inputBytes: bytes);
    } catch (_) {
      try {
        doc = PdfDocument(inputBytes: bytes, password: '');
      } catch (e) {
        throw Exception('Cannot parse PDF: $e');
      }
    }

    final savedBytes = await doc.save();
    doc.dispose();
    final outputPath = await FileUtils.getOutputPath('repaired');
    await File(outputPath).writeAsBytes(savedBytes);
    return outputPath;
  }
}
