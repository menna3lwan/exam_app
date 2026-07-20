import '../../../../core/network/api_results.dart';
import '../repos/auth_repository.dart';

class VerifyCodeUseCase {
  final AuthRepository _repository;

  VerifyCodeUseCase(this._repository);

  Future<ApiResults<void>> call({
    required String email,
    required String code,
  }) {
    return _repository.verifyCode(email: email, code: code);
  }
}
