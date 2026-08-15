import '../../../../core/result/result.dart';
import '../../domain/repositories/conversion_repository.dart';
import '../datasources/conversion_data_source.dart';

class ConversionRepositoryImpl implements ConversionRepository {
  final ConversionDataSource _ds;
  ConversionRepositoryImpl(this._ds);

  @override
  Future<Result<List<String>>> pdfToImages(String path) async {
    try {
      return Result.success(await _ds.pdfToImages(path));
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<String>> imagesToPdf(List<String> imagePaths) async {
    try {
      return Result.success(await _ds.imagesToPdf(imagePaths));
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<String>> pdfToWord(String path) async {
    try {
      return Result.success(await _ds.pdfToWord(path));
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<String>> pdfToExcel(String path) async {
    try {
      return Result.success(await _ds.pdfToExcel(path));
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<String>> pdfToPpt(String path) async {
    try {
      return Result.success(await _ds.pdfToPpt(path));
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<String>> htmlToPdf(String htmlContent) async {
    try {
      return Result.success(await _ds.htmlToPdf(htmlContent));
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}
