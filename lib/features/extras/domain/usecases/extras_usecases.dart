import '../../../../core/result/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/extras_repository.dart';

class OcrPdf implements UseCase<String, String> {
  final ExtrasRepository _repo;
  OcrPdf(this._repo);
  @override
  Future<Result<String>> call(String path) => _repo.ocrPdf(path);
}

class ComparePdfsParams {
  final String path1;
  final String path2;
  const ComparePdfsParams({required this.path1, required this.path2});
}

class ComparePdfs implements UseCase<String, ComparePdfsParams> {
  final ExtrasRepository _repo;
  ComparePdfs(this._repo);
  @override
  Future<Result<String>> call(ComparePdfsParams p) =>
      _repo.comparePdfs(p.path1, p.path2);
}

class RepairPdf implements UseCase<String, String> {
  final ExtrasRepository _repo;
  RepairPdf(this._repo);
  @override
  Future<Result<String>> call(String path) => _repo.repairPdf(path);
}
