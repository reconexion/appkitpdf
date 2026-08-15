import '../../../../core/result/result.dart';
import '../../domain/repositories/editing_repository.dart';
import '../datasources/editing_data_source.dart';

class EditingRepositoryImpl implements EditingRepository {
  final EditingDataSource _ds;
  EditingRepositoryImpl(this._ds);

  @override
  Future<Result<String>> addPageNumbers(
      String path, PageNumberPosition position) async {
    try {
      return Result.success(await _ds.addPageNumbers(path, position));
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<String>> addTextOverlay(
      String path, String text, double fontSize, double opacity,
      {bool allPages = true, int? specificPage}) async {
    try {
      return Result.success(await _ds.addTextOverlay(
          path, text, fontSize, opacity, allPages, specificPage));
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}
