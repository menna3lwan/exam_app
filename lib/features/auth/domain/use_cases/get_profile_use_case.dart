import '../../../../core/network/api_results.dart';
import '../../data/models/user_model.dart';
import '../repos/auth_repository.dart';

class GetProfileUseCase {
  final AuthRepository _repository;

  GetProfileUseCase(this._repository);

  Future<ApiResults<UserModel>> call() {
    return _repository.getProfile();
  }
}
