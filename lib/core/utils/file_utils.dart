import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart' as pdfx;

class FileUtils {
  static Future<int> getPdfPageCount(String path) async {
    final doc = await pdfx.PdfDocument.openFile(path);
    final count = doc.pagesCount;
    await doc.close();
    return count;
  }

  static Future<String> getOutputPath(String operation, {String extension = 'pdf'}) async {
    final dir = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '${dir.path}/${operation}_$timestamp.$extension';
  }

  static Future<String> getTempPath(String name, {String extension = 'jpg'}) async {
    final dir = await getTemporaryDirectory();
    return '${dir.path}/${name}_${DateTime.now().millisecondsSinceEpoch}.$extension';
  }

  /// Builds a fresh output path for a user-chosen file name, sanitized and
  /// de-duplicated (appends " (1)", " (2)", ... if the name is taken).
  static Future<String> getRenamedPath(String desiredName,
      {String extension = 'pdf'}) async {
    final dir = await getApplicationDocumentsDirectory();
    var sanitized = desiredName.trim();
    sanitized = sanitized.replaceAll(RegExp('\\.$extension\$', caseSensitive: false), '');
    sanitized = sanitized.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
    if (sanitized.isEmpty) sanitized = 'renamed';

    var candidate = '${dir.path}/$sanitized.$extension';
    var counter = 1;
    while (await File(candidate).exists()) {
      candidate = '${dir.path}/$sanitized ($counter).$extension';
      counter++;
    }
    return candidate;
  }

  static String xmlEscape(String s) => s
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;')
      .replaceAll("'", '&apos;');

  static Future<void> deleteSafe(String path) async {
    try {
      final f = File(path);
      if (await f.exists()) await f.delete();
    } catch (_) {}
  }
}
