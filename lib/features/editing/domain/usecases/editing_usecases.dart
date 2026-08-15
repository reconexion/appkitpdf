import '../../../../core/result/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/editing_repository.dart';

class AddPageNumbersParams {
  final String path;
  final PageNumberPosition position;
  const AddPageNumbersParams({required this.path, required this.position});
}

class AddPageNumbers implements UseCase<String, AddPageNumbersParams> {
  final EditingRepository _repo;
  AddPageNumbers(this._repo);
  @override
  Future<Result<String>> call(AddPageNumbersParams p) =>
      _repo.addPageNumbers(p.path, p.position);
}

class AddTextOverlayParams {
  final String path;
  final String text;
  final double fontSize;
  final double opacity;
  final bool allPages;
  final int? specificPage;
  const AddTextOverlayParams({
    required this.path,
    required this.text,
    this.fontSize = 36,
    this.opacity = 0.3,
    this.allPages = true,
    this.specificPage,
  });
}

class AddTextOverlay implements UseCase<String, AddTextOverlayParams> {
  final EditingRepository _repo;
  AddTextOverlay(this._repo);
  @override
  Future<Result<String>> call(AddTextOverlayParams p) => _repo.addTextOverlay(
        p.path, p.text, p.fontSize, p.opacity,
        allPages: p.allPages, specificPage: p.specificPage);
}
