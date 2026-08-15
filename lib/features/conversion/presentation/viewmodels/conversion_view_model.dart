import 'package:flutter/foundation.dart';
import '../../../../core/result/result.dart';
import '../../domain/usecases/conversion_usecases.dart';

class ConversionViewModel extends ChangeNotifier {
  final PdfToImages _pdfToImages;
  final ImagesToPdf _imagesToPdf;
  final PdfToWord _pdfToWord;
  final PdfToExcel _pdfToExcel;
  final PdfToPpt _pdfToPpt;
  final HtmlToPdf _htmlToPdf;

  ConversionViewModel({
    required PdfToImages pdfToImages,
    required ImagesToPdf imagesToPdf,
    required PdfToWord pdfToWord,
    required PdfToExcel pdfToExcel,
    required PdfToPpt pdfToPpt,
    required HtmlToPdf htmlToPdf,
  })  : _pdfToImages = pdfToImages,
        _imagesToPdf = imagesToPdf,
        _pdfToWord = pdfToWord,
        _pdfToExcel = pdfToExcel,
        _pdfToPpt = pdfToPpt,
        _htmlToPdf = htmlToPdf;

  String? pdfToImagesFile;
  bool isConvertingToImages = false;
  OperationResult? pdfToImagesResult;

  List<String> imagesToPdfFiles = [];
  bool isConvertingToPdf = false;
  OperationResult? imagesToPdfResult;

  String? pdfToWordFile;
  bool isConvertingToWord = false;
  OperationResult? pdfToWordResult;

  String? pdfToExcelFile;
  bool isConvertingToExcel = false;
  OperationResult? pdfToExcelResult;

  String? pdfToPptFile;
  bool isConvertingToPpt = false;
  OperationResult? pdfToPptResult;

  bool isConvertingHtml = false;
  OperationResult? htmlToPdfResult;

  Future<void> convertPdfToImages() async {
    if (pdfToImagesFile == null) return;
    isConvertingToImages = true;
    pdfToImagesResult = null;
    notifyListeners();

    final result = await _pdfToImages(pdfToImagesFile!);
    pdfToImagesResult = result.isSuccess
        ? OperationResult.success(outputPaths: result.data)
        : OperationResult.failure(result.error!);
    isConvertingToImages = false;
    notifyListeners();
  }

  Future<void> convertImagesToPdf() async {
    if (imagesToPdfFiles.isEmpty) return;
    isConvertingToPdf = true;
    imagesToPdfResult = null;
    notifyListeners();

    final result = await _imagesToPdf(ImagesToPdfParams(imagesToPdfFiles));
    imagesToPdfResult = result.isSuccess
        ? OperationResult.success(outputPath: result.data)
        : OperationResult.failure(result.error!);
    isConvertingToPdf = false;
    notifyListeners();
  }

  Future<void> convertPdfToWord() async {
    if (pdfToWordFile == null) return;
    isConvertingToWord = true;
    pdfToWordResult = null;
    notifyListeners();

    final result = await _pdfToWord(pdfToWordFile!);
    pdfToWordResult = result.isSuccess
        ? OperationResult.success(outputPath: result.data)
        : OperationResult.failure(result.error!);
    isConvertingToWord = false;
    notifyListeners();
  }

  Future<void> convertPdfToExcel() async {
    if (pdfToExcelFile == null) return;
    isConvertingToExcel = true;
    pdfToExcelResult = null;
    notifyListeners();

    final result = await _pdfToExcel(pdfToExcelFile!);
    pdfToExcelResult = result.isSuccess
        ? OperationResult.success(outputPath: result.data)
        : OperationResult.failure(result.error!);
    isConvertingToExcel = false;
    notifyListeners();
  }

  Future<void> convertPdfToPpt() async {
    if (pdfToPptFile == null) return;
    isConvertingToPpt = true;
    pdfToPptResult = null;
    notifyListeners();

    final result = await _pdfToPpt(pdfToPptFile!);
    pdfToPptResult = result.isSuccess
        ? OperationResult.success(outputPath: result.data)
        : OperationResult.failure(result.error!);
    isConvertingToPpt = false;
    notifyListeners();
  }

  Future<void> convertHtmlToPdf(String html) async {
    if (html.trim().isEmpty) return;
    isConvertingHtml = true;
    htmlToPdfResult = null;
    notifyListeners();

    final result = await _htmlToPdf(html);
    htmlToPdfResult = result.isSuccess
        ? OperationResult.success(outputPath: result.data)
        : OperationResult.failure(result.error!);
    isConvertingHtml = false;
    notifyListeners();
  }
}
