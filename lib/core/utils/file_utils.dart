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

  /// Moves an already-produced output file to a new, sanitized and
  /// de-duplicated name (same extension), used by the rename action on
  /// the result card. Tries a fast in-place rename first, falls back to
  /// copy+delete if the platform can't rename across directories.
  static Future<String> renameOutputFile(String oldPath, String newName) async {
    final oldName = oldPath.split(RegExp(r'[\\/]')).last;
    final dot = oldName.lastIndexOf('.');
    final ext = dot > 0 ? oldName.substring(dot + 1) : 'pdf';
    final newPath = await getRenamedPath(newName, extension: ext);
    final oldFile = File(oldPath);
    try {
      final renamed = await oldFile.rename(newPath);
      return renamed.path;
    } catch (_) {
      await oldFile.copy(newPath);
      await deleteSafe(oldPath);
      return newPath;
    }
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

  static String formatFileSize(int bytes) {
    if (bytes <= 0) return '0 B';
    const units = ['B', 'KB', 'MB', 'GB'];
    var size = bytes.toDouble();
    var unitIndex = 0;
    while (size >= 1024 && unitIndex < units.length - 1) {
      size /= 1024;
      unitIndex++;
    }
    final formatted =
        unitIndex == 0 ? size.toStringAsFixed(0) : size.toStringAsFixed(1);
    return '$formatted ${units[unitIndex]}';
  }

  static String formatRecentDate(DateTime dt, {required String todayLabel}) {
    final now = DateTime.now();
    final isToday =
        dt.year == now.year && dt.month == now.month && dt.day == now.day;
    final hour12 = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    final time = '$hour12:$minute $period';
    if (isToday) return '$todayLabel, $time';
    final day = dt.day.toString().padLeft(2, '0');
    final month = dt.month.toString().padLeft(2, '0');
    return '$day/$month, $time';
  }
}
