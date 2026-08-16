import 'dart:io';
import 'dart:ui';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../../../../core/utils/file_utils.dart';

abstract class OrganizationDataSource {
  Future<String> mergePdfs(List<String> paths);
  Future<List<String>> splitPdf(String path, List<List<int>> pageRanges);
  Future<String> removePages(String path, List<int> pageNumbers);
  Future<String> extractPages(String path, List<int> pageNumbers);
  Future<String> reorderPages(String path, List<int> newOrder);
  Future<String> rotatePages(String path, Map<int, int> pageRotations);
  Future<String> renamePdf(String path, String newName);
}

class OrganizationDataSourceImpl implements OrganizationDataSource {
  @override
  Future<String> mergePdfs(List<String> paths) async {
    final mergedDoc = PdfDocument();
    for (final path in paths) {
      final bytes = await File(path).readAsBytes();
      final srcDoc = PdfDocument(inputBytes: bytes);
      for (int i = 0; i < srcDoc.pages.count; i++) {
        final srcPage = srcDoc.pages[i];
        mergedDoc.pageSettings.size = srcPage.size;
        mergedDoc.pageSettings.margins.all = 0;
        final newPage = mergedDoc.pages.add();
        final template = srcPage.createTemplate();
        newPage.graphics.drawPdfTemplate(template, Offset.zero);
      }
      srcDoc.dispose();
    }
    final savedBytes = await mergedDoc.save();
    mergedDoc.dispose();
    final outputPath = await FileUtils.getOutputPath('merged');
    await File(outputPath).writeAsBytes(savedBytes);
    return outputPath;
  }

  @override
  Future<List<String>> splitPdf(String path, List<List<int>> pageRanges) async {
    final bytes = await File(path).readAsBytes();
    final srcDoc = PdfDocument(inputBytes: bytes);
    final outputPaths = <String>[];

    for (int r = 0; r < pageRanges.length; r++) {
      final outputDoc = PdfDocument();
      for (final pageNum in pageRanges[r]) {
        if (pageNum < 1 || pageNum > srcDoc.pages.count) continue;
        final srcPage = srcDoc.pages[pageNum - 1];
        outputDoc.pageSettings.size = srcPage.size;
        outputDoc.pageSettings.margins.all = 0;
        final newPage = outputDoc.pages.add();
        final template = srcPage.createTemplate();
        newPage.graphics.drawPdfTemplate(template, Offset.zero);
      }
      final savedBytes = await outputDoc.save();
      outputDoc.dispose();
      final outputPath = await FileUtils.getOutputPath('split_part${r + 1}');
      await File(outputPath).writeAsBytes(savedBytes);
      outputPaths.add(outputPath);
    }
    srcDoc.dispose();
    return outputPaths;
  }

  @override
  Future<String> removePages(String path, List<int> pageNumbers) async {
    return _copyFiltering(
        path, Set<int>.from(pageNumbers.map((p) => p - 1)),
        keep: false, label: 'removed_pages');
  }

  @override
  Future<String> extractPages(String path, List<int> pageNumbers) async {
    return _copyFiltering(
        path, Set<int>.from(pageNumbers.map((p) => p - 1)),
        keep: true, label: 'extracted');
  }

  @override
  Future<String> reorderPages(String path, List<int> newOrder) async {
    final bytes = await File(path).readAsBytes();
    final srcDoc = PdfDocument(inputBytes: bytes);
    final outputDoc = PdfDocument();

    for (final pageNum in newOrder) {
      if (pageNum < 1 || pageNum > srcDoc.pages.count) continue;
      final srcPage = srcDoc.pages[pageNum - 1];
      outputDoc.pageSettings.size = srcPage.size;
      outputDoc.pageSettings.margins.all = 0;
      final newPage = outputDoc.pages.add();
      final template = srcPage.createTemplate();
      newPage.graphics.drawPdfTemplate(template, Offset.zero);
    }

    srcDoc.dispose();
    final savedBytes = await outputDoc.save();
    outputDoc.dispose();
    final outputPath = await FileUtils.getOutputPath('reordered');
    await File(outputPath).writeAsBytes(savedBytes);
    return outputPath;
  }

  @override
  Future<String> rotatePages(String path, Map<int, int> pageRotations) async {
    final bytes = await File(path).readAsBytes();
    final doc = PdfDocument(inputBytes: bytes);

    for (final entry in pageRotations.entries) {
      final idx = entry.key - 1;
      if (idx < 0 || idx >= doc.pages.count) continue;
      doc.pages[idx].rotation = _toRotateAngle(entry.value);
    }

    final savedBytes = await doc.save();
    doc.dispose();
    final outputPath = await FileUtils.getOutputPath('rotated');
    await File(outputPath).writeAsBytes(savedBytes);
    return outputPath;
  }

  Future<String> _copyFiltering(String path, Set<int> indices,
      {required bool keep, required String label}) async {
    final bytes = await File(path).readAsBytes();
    final srcDoc = PdfDocument(inputBytes: bytes);
    final outputDoc = PdfDocument();

    for (int i = 0; i < srcDoc.pages.count; i++) {
      final include = keep ? indices.contains(i) : !indices.contains(i);
      if (!include) continue;
      final srcPage = srcDoc.pages[i];
      outputDoc.pageSettings.size = srcPage.size;
      outputDoc.pageSettings.margins.all = 0;
      final newPage = outputDoc.pages.add();
      final template = srcPage.createTemplate();
      newPage.graphics.drawPdfTemplate(template, Offset.zero);
    }

    srcDoc.dispose();
    final savedBytes = await outputDoc.save();
    outputDoc.dispose();
    final outputPath = await FileUtils.getOutputPath(label);
    await File(outputPath).writeAsBytes(savedBytes);
    return outputPath;
  }

  @override
  Future<String> renamePdf(String path, String newName) async {
    final bytes = await File(path).readAsBytes();
    final outputPath = await FileUtils.getRenamedPath(newName);
    await File(outputPath).writeAsBytes(bytes);
    return outputPath;
  }

  PdfPageRotateAngle _toRotateAngle(int degrees) {
    switch (degrees) {
      case 90:
        return PdfPageRotateAngle.rotateAngle90;
      case 180:
        return PdfPageRotateAngle.rotateAngle180;
      case 270:
        return PdfPageRotateAngle.rotateAngle270;
      default:
        return PdfPageRotateAngle.rotateAngle0;
    }
  }
}
