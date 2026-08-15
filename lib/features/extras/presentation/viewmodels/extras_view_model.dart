import 'package:flutter/foundation.dart';
import '../../../../core/result/result.dart';
import '../../domain/usecases/extras_usecases.dart';

class ExtrasViewModel extends ChangeNotifier {
  final OcrPdf _ocrPdf;
  final ComparePdfs _comparePdfs;
  final RepairPdf _repairPdf;

  ExtrasViewModel({
    required OcrPdf ocrPdf,
    required ComparePdfs comparePdfs,
    required RepairPdf repairPdf,
  })  : _ocrPdf = ocrPdf,
        _comparePdfs = comparePdfs,
        _repairPdf = repairPdf;

  String? ocrFile;
  bool isOcring = false;
  OperationResult? ocrResult;

  String? compareFile1;
  String? compareFile2;
  bool isComparing = false;
  OperationResult? compareResult;

  String? repairFile;
  bool isRepairing = false;
  OperationResult? repairResult;

  Future<void> ocr() async {
    if (ocrFile == null) return;
    isOcring = true;
    ocrResult = null;
    notifyListeners();

    final result = await _ocrPdf(ocrFile!);
    ocrResult = result.isSuccess
        ? OperationResult.success(outputPath: result.data)
        : OperationResult.failure(result.error!);
    isOcring = false;
    notifyListeners();
  }

  Future<void> compare() async {
    if (compareFile1 == null || compareFile2 == null) return;
    isComparing = true;
    compareResult = null;
    notifyListeners();

    final result = await _comparePdfs(
        ComparePdfsParams(path1: compareFile1!, path2: compareFile2!));
    compareResult = result.isSuccess
        ? OperationResult.success(outputPath: result.data)
        : OperationResult.failure(result.error!);
    isComparing = false;
    notifyListeners();
  }

  Future<void> repair() async {
    if (repairFile == null) return;
    isRepairing = true;
    repairResult = null;
    notifyListeners();

    final result = await _repairPdf(repairFile!);
    repairResult = result.isSuccess
        ? OperationResult.success(outputPath: result.data)
        : OperationResult.failure(result.error!);
    isRepairing = false;
    notifyListeners();
  }
}
