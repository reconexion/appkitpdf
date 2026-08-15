import '../../../../core/result/result.dart';

abstract class ExtrasRepository {
  Future<Result<String>> ocrPdf(String path);
  Future<Result<String>> comparePdfs(String path1, String path2);
  Future<Result<String>> repairPdf(String path);
}
