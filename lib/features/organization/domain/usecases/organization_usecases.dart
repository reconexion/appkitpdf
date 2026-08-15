import '../../../../core/result/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/organization_repository.dart';

class MergePdfsParams {
  final List<String> paths;
  const MergePdfsParams(this.paths);
}

class MergePdfs implements UseCase<String, MergePdfsParams> {
  final OrganizationRepository _repo;
  MergePdfs(this._repo);
  @override
  Future<Result<String>> call(MergePdfsParams p) => _repo.mergePdfs(p.paths);
}

class SplitPdfParams {
  final String path;
  final List<List<int>> pageRanges;
  const SplitPdfParams({required this.path, required this.pageRanges});
}

class SplitPdf implements UseCase<List<String>, SplitPdfParams> {
  final OrganizationRepository _repo;
  SplitPdf(this._repo);
  @override
  Future<Result<List<String>>> call(SplitPdfParams p) =>
      _repo.splitPdf(p.path, p.pageRanges);
}

class RemovePagesParams {
  final String path;
  final List<int> pageNumbers;
  const RemovePagesParams({required this.path, required this.pageNumbers});
}

class RemovePages implements UseCase<String, RemovePagesParams> {
  final OrganizationRepository _repo;
  RemovePages(this._repo);
  @override
  Future<Result<String>> call(RemovePagesParams p) =>
      _repo.removePages(p.path, p.pageNumbers);
}

class ExtractPagesParams {
  final String path;
  final List<int> pageNumbers;
  const ExtractPagesParams({required this.path, required this.pageNumbers});
}

class ExtractPages implements UseCase<String, ExtractPagesParams> {
  final OrganizationRepository _repo;
  ExtractPages(this._repo);
  @override
  Future<Result<String>> call(ExtractPagesParams p) =>
      _repo.extractPages(p.path, p.pageNumbers);
}

class ReorderPagesParams {
  final String path;
  final List<int> newOrder;
  const ReorderPagesParams({required this.path, required this.newOrder});
}

class ReorderPages implements UseCase<String, ReorderPagesParams> {
  final OrganizationRepository _repo;
  ReorderPages(this._repo);
  @override
  Future<Result<String>> call(ReorderPagesParams p) =>
      _repo.reorderPages(p.path, p.newOrder);
}

class RotatePagesParams {
  final String path;
  final Map<int, int> pageRotations;
  const RotatePagesParams({required this.path, required this.pageRotations});
}

class RotatePages implements UseCase<String, RotatePagesParams> {
  final OrganizationRepository _repo;
  RotatePages(this._repo);
  @override
  Future<Result<String>> call(RotatePagesParams p) =>
      _repo.rotatePages(p.path, p.pageRotations);
}
