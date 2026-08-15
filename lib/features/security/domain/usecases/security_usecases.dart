import '../../../../core/result/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/security_repository.dart';

class ProtectPdfParams {
  final String path;
  final String password;
  const ProtectPdfParams({required this.path, required this.password});
}

class ProtectPdf implements UseCase<String, ProtectPdfParams> {
  final SecurityRepository _repo;
  ProtectPdf(this._repo);
  @override
  Future<Result<String>> call(ProtectPdfParams p) =>
      _repo.protectPdf(p.path, p.password);
}

class UnprotectPdfParams {
  final String path;
  final String currentPassword;
  const UnprotectPdfParams({required this.path, required this.currentPassword});
}

class UnprotectPdf implements UseCase<String, UnprotectPdfParams> {
  final SecurityRepository _repo;
  UnprotectPdf(this._repo);
  @override
  Future<Result<String>> call(UnprotectPdfParams p) =>
      _repo.unprotectPdf(p.path, p.currentPassword);
}

class CompressPdf implements UseCase<String, String> {
  final SecurityRepository _repo;
  CompressPdf(this._repo);
  @override
  Future<Result<String>> call(String path) => _repo.compressPdf(path);
}
