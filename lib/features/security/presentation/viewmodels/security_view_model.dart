import 'package:flutter/foundation.dart';
import '../../../../core/result/result.dart';
import '../../domain/usecases/security_usecases.dart';

class SecurityViewModel extends ChangeNotifier {
  final ProtectPdf _protectPdf;
  final UnprotectPdf _unprotectPdf;
  final CompressPdf _compressPdf;

  SecurityViewModel({
    required ProtectPdf protectPdf,
    required UnprotectPdf unprotectPdf,
    required CompressPdf compressPdf,
  })  : _protectPdf = protectPdf,
        _unprotectPdf = unprotectPdf,
        _compressPdf = compressPdf;

  String? _protectFile;
  String? get protectFile => _protectFile;
  set protectFile(String? v) {
    _protectFile = v;
    notifyListeners();
  }

  bool isProtecting = false;
  OperationResult? protectResult;

  String? _unprotectFile;
  String? get unprotectFile => _unprotectFile;
  set unprotectFile(String? v) {
    _unprotectFile = v;
    notifyListeners();
  }

  bool isUnprotecting = false;
  OperationResult? unprotectResult;

  String? _compressFile;
  String? get compressFile => _compressFile;
  set compressFile(String? v) {
    _compressFile = v;
    notifyListeners();
  }

  bool isCompressing = false;
  OperationResult? compressResult;

  Future<void> protect(String password) async {
    if (protectFile == null || password.isEmpty) return;
    isProtecting = true;
    protectResult = null;
    notifyListeners();

    final result = await _protectPdf(
        ProtectPdfParams(path: protectFile!, password: password));
    protectResult = result.isSuccess
        ? OperationResult.success(outputPath: result.data)
        : OperationResult.failure(result.error!);
    isProtecting = false;
    notifyListeners();
  }

  Future<void> unprotect(String currentPassword) async {
    if (unprotectFile == null) return;
    isUnprotecting = true;
    unprotectResult = null;
    notifyListeners();

    final result = await _unprotectPdf(UnprotectPdfParams(
        path: unprotectFile!, currentPassword: currentPassword));
    unprotectResult = result.isSuccess
        ? OperationResult.success(outputPath: result.data)
        : OperationResult.failure(result.error!);
    isUnprotecting = false;
    notifyListeners();
  }

  Future<void> compress() async {
    if (compressFile == null) return;
    isCompressing = true;
    compressResult = null;
    notifyListeners();

    final result = await _compressPdf(compressFile!);
    compressResult = result.isSuccess
        ? OperationResult.success(outputPath: result.data)
        : OperationResult.failure(result.error!);
    isCompressing = false;
    notifyListeners();
  }
}
