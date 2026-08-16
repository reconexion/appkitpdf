import 'package:flutter/foundation.dart';
import '../../../../core/result/result.dart';
import '../../domain/usecases/organization_usecases.dart';

class OrganizationViewModel extends ChangeNotifier {
  final MergePdfs _mergePdfs;
  final SplitPdf _splitPdf;
  final RemovePages _removePages;
  final ExtractPages _extractPages;
  final ReorderPages _reorderPages;
  final RotatePages _rotatePages;
  final RenamePdf _renamePdf;

  OrganizationViewModel({
    required MergePdfs mergePdfs,
    required SplitPdf splitPdf,
    required RemovePages removePages,
    required ExtractPages extractPages,
    required ReorderPages reorderPages,
    required RotatePages rotatePages,
    required RenamePdf renamePdf,
  })  : _mergePdfs = mergePdfs,
        _splitPdf = splitPdf,
        _removePages = removePages,
        _extractPages = extractPages,
        _reorderPages = reorderPages,
        _rotatePages = rotatePages,
        _renamePdf = renamePdf;

  // Merge state
  List<String> _mergeFiles = [];
  List<String> get mergeFiles => _mergeFiles;
  set mergeFiles(List<String> v) {
    _mergeFiles = v;
    notifyListeners();
  }

  bool isMerging = false;
  OperationResult? mergeResult;

  // Split state
  String? _splitFile;
  String? get splitFile => _splitFile;
  set splitFile(String? v) {
    _splitFile = v;
    notifyListeners();
  }

  bool isSplitting = false;
  OperationResult? splitResult;

  // Remove pages state
  String? _removeFile;
  String? get removeFile => _removeFile;
  set removeFile(String? v) {
    _removeFile = v;
    notifyListeners();
  }

  bool isRemoving = false;
  OperationResult? removeResult;

  // Extract pages state
  String? _extractFile;
  String? get extractFile => _extractFile;
  set extractFile(String? v) {
    _extractFile = v;
    notifyListeners();
  }

  bool isExtracting = false;
  OperationResult? extractResult;

  // Reorder state
  String? _reorderFile;
  String? get reorderFile => _reorderFile;
  set reorderFile(String? v) {
    _reorderFile = v;
    notifyListeners();
  }

  bool isReordering = false;
  OperationResult? reorderResult;

  // Rotate state
  String? _rotateFile;
  String? get rotateFile => _rotateFile;
  set rotateFile(String? v) {
    _rotateFile = v;
    notifyListeners();
  }

  bool isRotating = false;
  OperationResult? rotateResult;

  // Rename state
  String? _renameFile;
  String? get renameFile => _renameFile;
  set renameFile(String? v) {
    _renameFile = v;
    notifyListeners();
  }

  bool isRenaming = false;
  OperationResult? renameResult;

  Future<void> merge() async {
    if (mergeFiles.length < 2) return;
    isMerging = true;
    mergeResult = null;
    notifyListeners();

    final result = await _mergePdfs(MergePdfsParams(mergeFiles));
    mergeResult = result.isSuccess
        ? OperationResult.success(outputPath: result.data)
        : OperationResult.failure(result.error!);
    isMerging = false;
    notifyListeners();
  }

  Future<void> split(List<List<int>> pageRanges) async {
    if (splitFile == null) return;
    isSplitting = true;
    splitResult = null;
    notifyListeners();

    final result = await _splitPdf(
        SplitPdfParams(path: splitFile!, pageRanges: pageRanges));
    splitResult = result.isSuccess
        ? OperationResult.success(outputPaths: result.data)
        : OperationResult.failure(result.error!);
    isSplitting = false;
    notifyListeners();
  }

  Future<void> removePages(List<int> pages) async {
    if (removeFile == null) return;
    isRemoving = true;
    removeResult = null;
    notifyListeners();

    final result = await _removePages(
        RemovePagesParams(path: removeFile!, pageNumbers: pages));
    removeResult = result.isSuccess
        ? OperationResult.success(outputPath: result.data)
        : OperationResult.failure(result.error!);
    isRemoving = false;
    notifyListeners();
  }

  Future<void> extractPages(List<int> pages) async {
    if (extractFile == null) return;
    isExtracting = true;
    extractResult = null;
    notifyListeners();

    final result = await _extractPages(
        ExtractPagesParams(path: extractFile!, pageNumbers: pages));
    extractResult = result.isSuccess
        ? OperationResult.success(outputPath: result.data)
        : OperationResult.failure(result.error!);
    isExtracting = false;
    notifyListeners();
  }

  Future<void> reorderPages(List<int> newOrder) async {
    if (reorderFile == null) return;
    isReordering = true;
    reorderResult = null;
    notifyListeners();

    final result = await _reorderPages(
        ReorderPagesParams(path: reorderFile!, newOrder: newOrder));
    reorderResult = result.isSuccess
        ? OperationResult.success(outputPath: result.data)
        : OperationResult.failure(result.error!);
    isReordering = false;
    notifyListeners();
  }

  Future<void> rotatePages(Map<int, int> pageRotations) async {
    if (rotateFile == null) return;
    isRotating = true;
    rotateResult = null;
    notifyListeners();

    final result = await _rotatePages(
        RotatePagesParams(path: rotateFile!, pageRotations: pageRotations));
    rotateResult = result.isSuccess
        ? OperationResult.success(outputPath: result.data)
        : OperationResult.failure(result.error!);
    isRotating = false;
    notifyListeners();
  }

  Future<void> rename(String newName) async {
    if (renameFile == null || newName.trim().isEmpty) return;
    isRenaming = true;
    renameResult = null;
    notifyListeners();

    final result = await _renamePdf(
        RenamePdfParams(path: renameFile!, newName: newName));
    renameResult = result.isSuccess
        ? OperationResult.success(outputPath: result.data)
        : OperationResult.failure(result.error!);
    isRenaming = false;
    notifyListeners();
  }
}
