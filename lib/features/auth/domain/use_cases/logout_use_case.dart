import '../../../../core/network/api_results.dart';
import '../repos/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository _repository;

  LogoutUseCase(this._repository);

  Future<ApiResults<void>> call() {
    return _repository.logout();
  }
}
