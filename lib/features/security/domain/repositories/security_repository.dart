import '../../../../core/result/result.dart';

abstract class SecurityRepository {
  Future<Result<String>> protectPdf(String path, String password);
  Future<Result<String>> unprotectPdf(String path, String currentPassword);
  Future<Result<String>> compressPdf(String path);
}
