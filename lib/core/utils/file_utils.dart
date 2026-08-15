import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileUtils {
  static Future<String> getOutputPath(String operation, {String extension = 'pdf'}) async {
    final dir = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '${dir.path}/${operation}_$timestamp.$extension';
  }

  static Future<String> getTempPath(String name, {String extension = 'jpg'}) async {
    final dir = await getTemporaryDirectory();
    return '${dir.path}/${name}_${DateTime.now().millisecondsSinceEpoch}.$extension';
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
