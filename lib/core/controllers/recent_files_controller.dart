import 'dart:io';
import 'package:flutter/foundation.dart';

class RecentFile {
  final String path;
  final DateTime processedAt;

  RecentFile({required this.path, required this.processedAt});

  String get name => path.split(RegExp(r'[\\/]')).last;

  int get sizeBytes {
    try {
      return File(path).lengthSync();
    } catch (_) {
      return 0;
    }
  }
}

/// Tracks PDFs produced by any tool so they can be listed under Recientes.
/// Session-only, no disk persistence. [ResultCard] records automatically
/// the first time a result succeeds, so no per-tool wiring is needed.
class RecentFilesController extends ChangeNotifier {
  final List<RecentFile> _files = [];

  List<RecentFile> get all => List.unmodifiable(_files);

  void record(String path) {
    _files.removeWhere((f) => f.path == path);
    _files.insert(0, RecentFile(path: path, processedAt: DateTime.now()));
    notifyListeners();
  }

  void remove(String path) {
    _files.removeWhere((f) => f.path == path);
    notifyListeners();
  }
}
