import '../../../../core/result/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/conversion_repository.dart';

class PdfToImages implements UseCase<List<String>, String> {
  final ConversionRepository _repo;
  PdfToImages(this._repo);
  @override
  Future<Result<List<String>>> call(String path) => _repo.pdfToImages(path);
}

class ImagesToPdfParams {
  final List<String> imagePaths;
  const ImagesToPdfParams(this.imagePaths);
}

class ImagesToPdf implements UseCase<String, ImagesToPdfParams> {
  final ConversionRepository _repo;
  ImagesToPdf(this._repo);
  @override
  Future<Result<String>> call(ImagesToPdfParams p) =>
      _repo.imagesToPdf(p.imagePaths);
}

class PdfToWord implements UseCase<String, String> {
  final ConversionRepository _repo;
  PdfToWord(this._repo);
  @override
  Future<Result<String>> call(String path) => _repo.pdfToWord(path);
}

class PdfToExcel implements UseCase<String, String> {
  final ConversionRepository _repo;
  PdfToExcel(this._repo);
  @override
  Future<Result<String>> call(String path) => _repo.pdfToExcel(path);
}

class PdfToPpt implements UseCase<String, String> {
  final ConversionRepository _repo;
  PdfToPpt(this._repo);
  @override
  Future<Result<String>> call(String path) => _repo.pdfToPpt(path);
}

class HtmlToPdf implements UseCase<String, String> {
  final ConversionRepository _repo;
  HtmlToPdf(this._repo);
  @override
  Future<Result<String>> call(String htmlContent) =>
      _repo.htmlToPdf(htmlContent);
}
