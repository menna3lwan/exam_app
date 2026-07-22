import '../../../../core/network/api_results.dart';
import '../repos/auth_repository.dart';

class ChangePasswordUseCase {
  final AuthRepository _repository;

  ChangePasswordUseCase(this._repository);

  Future<ApiResults<void>> call({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) {
    return _repository.changePassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );
  }
}
