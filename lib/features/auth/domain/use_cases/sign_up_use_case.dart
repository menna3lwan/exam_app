import '../../../../core/network/api_results.dart';
import '../../data/models/auth_response_model.dart';
import '../repos/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository _repository;

  SignUpUseCase(this._repository);

  Future<ApiResults<AuthResponseModel>> call({
    required String username,
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String confirmPassword,
    required String phone,
  }) {
    return _repository.signUp(
      username: username,
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      phone: phone,
    );
  }
}
