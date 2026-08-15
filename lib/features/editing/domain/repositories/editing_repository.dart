import '../../../../core/result/result.dart';

enum PageNumberPosition { bottomCenter, bottomRight, topCenter }

abstract class EditingRepository {
  Future<Result<String>> addPageNumbers(
      String path, PageNumberPosition position);
  Future<Result<String>> addTextOverlay(
      String path, String text, double fontSize, double opacity,
      {bool allPages = true, int? specificPage});
}
