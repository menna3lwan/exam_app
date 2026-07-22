import '../../../../core/network/api_results.dart';
import '../../data/models/user_model.dart';
import '../repos/auth_repository.dart';

class UpdateProfileUseCase {
  final AuthRepository _repository;

  UpdateProfileUseCase(this._repository);

  Future<ApiResults<UserModel>> call({
    String? username,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
  }) {
    return _repository.updateProfile(
      username: username,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
    );
  }
}
