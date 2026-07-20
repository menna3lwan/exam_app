import '../../../../core/network/api_results.dart';
import '../repos/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<ApiResults<void>> call({
    required String email,
    required String password,
  }) {
    return _repository.login(email: email, password: password);
  }
}
