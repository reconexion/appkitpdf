import 'dart:io';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../../../../core/utils/file_utils.dart';

abstract class SecurityDataSource {
  Future<String> protectPdf(String path, String password);
  Future<String> unprotectPdf(String path, String currentPassword);
  Future<String> compressPdf(String path);
}

class SecurityDataSourceImpl implements SecurityDataSource {
  @override
  Future<String> protectPdf(String path, String password) async {
    final bytes = await File(path).readAsBytes();
    final doc = PdfDocument(inputBytes: bytes);

    final security = doc.security;
    security.algorithm = PdfEncryptionAlgorithm.aesx256Bit;
    security.userPassword = password;
    security.ownerPassword = password;

    final savedBytes = await doc.save();
    doc.dispose();
    final outputPath = await FileUtils.getOutputPath('protected');
    await File(outputPath).writeAsBytes(savedBytes);
    return outputPath;
  }

  @override
  Future<String> unprotectPdf(String path, String currentPassword) async {
    final bytes = await File(path).readAsBytes();
    final doc = PdfDocument(inputBytes: bytes, password: currentPassword);

    doc.security.userPassword = '';
    doc.security.ownerPassword = '';

    final savedBytes = await doc.save();
    doc.dispose();
    final outputPath = await FileUtils.getOutputPath('unprotected');
    await File(outputPath).writeAsBytes(savedBytes);
    return outputPath;
  }

  @override
  Future<String> compressPdf(String path) async {
    final bytes = await File(path).readAsBytes();
    final doc = PdfDocument(inputBytes: bytes);

    doc.compressionLevel = PdfCompressionLevel.best;

    final savedBytes = await doc.save();
    doc.dispose();

    final outputPath = await FileUtils.getOutputPath('compressed');
    await File(outputPath).writeAsBytes(savedBytes);
    return outputPath;
  }
}
