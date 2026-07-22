import '../../../../core/network/api_results.dart';
import '../repos/auth_repository.dart';

class ResetPasswordUseCase {
  final AuthRepository _repository;

  ResetPasswordUseCase(this._repository);

  Future<ApiResults<void>> call({
    required String email,
    required String newPassword,
  }) {
    return _repository.resetPassword(email: email, newPassword: newPassword);
  }
}
