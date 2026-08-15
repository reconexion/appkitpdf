import '../../../../core/result/result.dart';
import '../../domain/repositories/security_repository.dart';
import '../datasources/security_data_source.dart';

class SecurityRepositoryImpl implements SecurityRepository {
  final SecurityDataSource _ds;
  SecurityRepositoryImpl(this._ds);

  @override
  Future<Result<String>> protectPdf(String path, String password) async {
    try {
      return Result.success(await _ds.protectPdf(path, password));
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<String>> unprotectPdf(
      String path, String currentPassword) async {
    try {
      return Result.success(await _ds.unprotectPdf(path, currentPassword));
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<String>> compressPdf(String path) async {
    try {
      return Result.success(await _ds.compressPdf(path));
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}
