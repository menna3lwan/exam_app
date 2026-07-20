import '../../../../core/network/api_results.dart';
import '../repos/auth_repository.dart';

class ForgetPasswordUseCase {
  final AuthRepository _repository;

  ForgetPasswordUseCase(this._repository);

  Future<ApiResults<void>> call({required String email}) {
    return _repository.forgetPassword(email: email);
  }
}
