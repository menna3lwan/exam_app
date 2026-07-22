import '../../../../core/network/api_results.dart';
import '../../data/models/auth_response_model.dart';
import '../repos/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<ApiResults<AuthResponseModel>> call({
    required String email,
    required String password,
    required bool rememberMe,
  }) {
    return _repository.login(
      email: email,
      password: password,
      rememberMe: rememberMe,
    );
  }
}
