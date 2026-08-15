import 'dart:io';
import 'dart:ui';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../../../../core/utils/file_utils.dart';
import '../../domain/repositories/editing_repository.dart';

abstract class EditingDataSource {
  Future<String> addPageNumbers(String path, PageNumberPosition position);
  Future<String> addTextOverlay(String path, String text, double fontSize,
      double opacity, bool allPages, int? specificPage);
}

class EditingDataSourceImpl implements EditingDataSource {
  @override
  Future<String> addPageNumbers(
      String path, PageNumberPosition position) async {
    final bytes = await File(path).readAsBytes();
    final doc = PdfDocument(inputBytes: bytes);
    final font = PdfStandardFont(PdfFontFamily.helvetica, 12);
    final total = doc.pages.count;

    for (int i = 0; i < total; i++) {
      final page = doc.pages[i];
      final pageText = 'Page ${i + 1} of $total';
      final measured = font.measureString(pageText);
      final w = page.size.width;
      final h = page.size.height;

      double x, y;
      switch (position) {
        case PageNumberPosition.bottomCenter:
          x = (w - measured.width) / 2;
          y = h - 30;
          break;
        case PageNumberPosition.bottomRight:
          x = w - measured.width - 20;
          y = h - 30;
          break;
        case PageNumberPosition.topCenter:
          x = (w - measured.width) / 2;
          y = 10;
          break;
      }

      page.graphics.drawString(
        pageText,
        font,
        bounds: Rect.fromLTWH(x, y, measured.width + 10, 20),
      );
    }

    final savedBytes = await doc.save();
    doc.dispose();
    final outputPath = await FileUtils.getOutputPath('page_numbered');
    await File(outputPath).writeAsBytes(savedBytes);
    return outputPath;
  }

  @override
  Future<String> addTextOverlay(String path, String text, double fontSize,
      double opacity, bool allPages, int? specificPage) async {
    final bytes = await File(path).readAsBytes();
    final doc = PdfDocument(inputBytes: bytes);
    final font = PdfStandardFont(PdfFontFamily.helvetica, fontSize,
        style: PdfFontStyle.bold);
    final alpha = (255 * opacity).clamp(0.0, 255.0).toInt();
    final brush = PdfSolidBrush(PdfColor(100, 100, 100, alpha));

    final startIdx = allPages ? 0 : (specificPage ?? 1) - 1;
    final endIdx = allPages ? doc.pages.count - 1 : startIdx;

    for (int i = startIdx; i <= endIdx; i++) {
      if (i < 0 || i >= doc.pages.count) continue;
      final page = doc.pages[i];
      final measured = font.measureString(text);
      page.graphics.drawString(
        text,
        font,
        brush: brush,
        bounds: Rect.fromLTWH(
          (page.size.width - measured.width) / 2,
          (page.size.height - measured.height) / 2,
          measured.width + 20,
          measured.height + 10,
        ),
      );
    }

    final savedBytes = await doc.save();
    doc.dispose();
    final outputPath = await FileUtils.getOutputPath('text_overlay');
    await File(outputPath).writeAsBytes(savedBytes);
    return outputPath;
  }
}
