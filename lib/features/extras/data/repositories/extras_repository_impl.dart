import '../../../../core/result/result.dart';
import '../../domain/repositories/extras_repository.dart';
import '../datasources/extras_data_source.dart';

class ExtrasRepositoryImpl implements ExtrasRepository {
  final ExtrasDataSource _ds;
  ExtrasRepositoryImpl(this._ds);

  @override
  Future<Result<String>> ocrPdf(String path) async {
    try {
      return Result.success(await _ds.ocrPdf(path));
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<String>> comparePdfs(String path1, String path2) async {
    try {
      return Result.success(await _ds.comparePdfs(path1, path2));
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<String>> repairPdf(String path) async {
    try {
      return Result.success(await _ds.repairPdf(path));
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}
