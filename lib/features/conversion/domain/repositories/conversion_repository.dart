import '../../../../core/result/result.dart';

abstract class ConversionRepository {
  Future<Result<List<String>>> pdfToImages(String path);
  Future<Result<String>> imagesToPdf(List<String> imagePaths);
  Future<Result<String>> pdfToWord(String path);
  Future<Result<String>> pdfToExcel(String path);
  Future<Result<String>> pdfToPpt(String path);
  Future<Result<String>> htmlToPdf(String htmlContent);
}
