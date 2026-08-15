import 'package:flutter/foundation.dart';
import '../../../../core/result/result.dart';
import '../../domain/repositories/editing_repository.dart';
import '../../domain/usecases/editing_usecases.dart';

class EditingViewModel extends ChangeNotifier {
  final AddPageNumbers _addPageNumbers;
  final AddTextOverlay _addTextOverlay;

  EditingViewModel({
    required AddPageNumbers addPageNumbers,
    required AddTextOverlay addTextOverlay,
  })  : _addPageNumbers = addPageNumbers,
        _addTextOverlay = addTextOverlay;

  String? _pageNumberFile;
  String? get pageNumberFile => _pageNumberFile;
  set pageNumberFile(String? v) {
    _pageNumberFile = v;
    notifyListeners();
  }

  bool isAddingPageNumbers = false;
  OperationResult? pageNumberResult;

  String? _overlayFile;
  String? get overlayFile => _overlayFile;
  set overlayFile(String? v) {
    _overlayFile = v;
    notifyListeners();
  }

  bool isAddingOverlay = false;
  OperationResult? overlayResult;

  Future<void> addPageNumbers(PageNumberPosition position) async {
    if (pageNumberFile == null) return;
    isAddingPageNumbers = true;
    pageNumberResult = null;
    notifyListeners();

    final result = await _addPageNumbers(
        AddPageNumbersParams(path: pageNumberFile!, position: position));
    pageNumberResult = result.isSuccess
        ? OperationResult.success(outputPath: result.data)
        : OperationResult.failure(result.error!);
    isAddingPageNumbers = false;
    notifyListeners();
  }

  Future<void> addTextOverlay(
      String text, double fontSize, double opacity,
      {bool allPages = true, int? specificPage}) async {
    if (overlayFile == null) return;
    isAddingOverlay = true;
    overlayResult = null;
    notifyListeners();

    final result = await _addTextOverlay(AddTextOverlayParams(
      path: overlayFile!,
      text: text,
      fontSize: fontSize,
      opacity: opacity,
      allPages: allPages,
      specificPage: specificPage,
    ));
    overlayResult = result.isSuccess
        ? OperationResult.success(outputPath: result.data)
        : OperationResult.failure(result.error!);
    isAddingOverlay = false;
    notifyListeners();
  }
}
