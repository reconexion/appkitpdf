import '../../../../core/result/result.dart';
import '../../domain/repositories/organization_repository.dart';
import '../datasources/organization_data_source.dart';

class OrganizationRepositoryImpl implements OrganizationRepository {
  final OrganizationDataSource _ds;
  OrganizationRepositoryImpl(this._ds);

  @override
  Future<Result<String>> mergePdfs(List<String> paths) async {
    try {
      return Result.success(await _ds.mergePdfs(paths));
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<List<String>>> splitPdf(
      String path, List<List<int>> pageRanges) async {
    try {
      return Result.success(await _ds.splitPdf(path, pageRanges));
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<String>> removePages(String path, List<int> pageNumbers) async {
    try {
      return Result.success(await _ds.removePages(path, pageNumbers));
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<String>> extractPages(
      String path, List<int> pageNumbers) async {
    try {
      return Result.success(await _ds.extractPages(path, pageNumbers));
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<String>> reorderPages(
      String path, List<int> newOrder) async {
    try {
      return Result.success(await _ds.reorderPages(path, newOrder));
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<String>> rotatePages(
      String path, Map<int, int> pageRotations) async {
    try {
      return Result.success(await _ds.rotatePages(path, pageRotations));
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<String>> renamePdf(String path, String newName) async {
    try {
      return Result.success(await _ds.renamePdf(path, newName));
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}
