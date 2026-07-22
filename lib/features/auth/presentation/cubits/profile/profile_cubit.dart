import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/network/api_results.dart';
import '../../../domain/use_cases/change_password_use_case.dart';
import '../../../domain/use_cases/get_profile_use_case.dart';
import '../../../domain/use_cases/update_profile_use_case.dart';
import '../../../data/models/user_model.dart';
import 'profile_state.dart';

/// Manages profile data loading, update, and password change.
///
/// State lifecycle:
///   Initial → Loading → Loaded / Error
///   Loaded → Updating → UpdateSuccess / UpdateError → Loaded
///   Loaded → PasswordChanging → PasswordChangeSuccess / PasswordChangeError → Loaded
class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase _getProfileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;
  final ChangePasswordUseCase _changePasswordUseCase;

  ProfileCubit({
    required GetProfileUseCase getProfileUseCase,
    required UpdateProfileUseCase updateProfileUseCase,
    required ChangePasswordUseCase changePasswordUseCase,
  })  : _getProfileUseCase = getProfileUseCase,
        _updateProfileUseCase = updateProfileUseCase,
        _changePasswordUseCase = changePasswordUseCase,
        super(const ProfileInitial());

  Future<void> loadProfile() async {
    emit(const ProfileLoading());

    final result = await _getProfileUseCase();
    if (isClosed) return;

    switch (result) {
      case Success(:final data):
        if (data != null) {
          emit(ProfileLoaded(data));
        } else {
          emit(const ProfileError('Could not load profile'));
        }
      case Failure(:final message):
        emit(ProfileError(message ?? 'Could not load profile'));
    }
  }

  Future<void> updateProfile({
    String? username,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
  }) async {
    final currentUser = _currentUser;
    if (currentUser == null) return;

    emit(ProfileUpdating(currentUser));

    final result = await _updateProfileUseCase(
      username: username,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
    );
    if (isClosed) return;

    switch (result) {
      case Success(:final data):
        final updatedUser = data ?? currentUser;
        emit(ProfileUpdateSuccess(updatedUser, 'Profile updated successfully'));
      case Failure(:final message):
        emit(ProfileUpdateError(
          currentUser,
          message ?? 'Could not update profile',
        ));
    }
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final currentUser = _currentUser;
    if (currentUser == null) return;

    emit(PasswordChanging(currentUser));

    final result = await _changePasswordUseCase(
      oldPassword: oldPassword,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );
    if (isClosed) return;

    switch (result) {
      case Success():
        emit(PasswordChangeSuccess(currentUser));
      case Failure(:final message):
        emit(PasswordChangeError(
          currentUser,
          message ?? 'Could not change password',
        ));
    }
  }

  /// Helper to extract user from any state that carries one.
  UserModel? get _currentUser => switch (state) {
        ProfileLoaded(:final user) => user,
        ProfileUpdating(:final user) => user,
        ProfileUpdateSuccess(:final user) => user,
        ProfileUpdateError(:final user) => user,
        PasswordChanging(:final user) => user,
        PasswordChangeSuccess(:final user) => user,
        PasswordChangeError(:final user) => user,
        _ => null,
      };
}
