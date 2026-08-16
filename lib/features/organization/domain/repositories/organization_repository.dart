import '../../../../core/result/result.dart';

abstract class OrganizationRepository {
  Future<Result<String>> mergePdfs(List<String> paths);
  Future<Result<List<String>>> splitPdf(String path, List<List<int>> pageRanges);
  Future<Result<String>> removePages(String path, List<int> pageNumbers);
  Future<Result<String>> extractPages(String path, List<int> pageNumbers);
  Future<Result<String>> reorderPages(String path, List<int> newOrder);
  Future<Result<String>> rotatePages(String path, Map<int, int> pageRotations);
  Future<Result<String>> renamePdf(String path, String newName);
}
