import '../../../data/models/user_model.dart';

/// Profile screen states — sealed for exhaustive switching.
sealed class ProfileState {
  const ProfileState();
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  final UserModel user;
  const ProfileLoaded(this.user);
}

class ProfileError extends ProfileState {
  final String message;
  const ProfileError(this.message);
}

/// Overlay states for update/change-password operations
/// that run while the profile is already loaded.
class ProfileUpdating extends ProfileState {
  final UserModel user;
  const ProfileUpdating(this.user);
}

class ProfileUpdateSuccess extends ProfileState {
  final UserModel user;
  final String message;
  const ProfileUpdateSuccess(this.user, this.message);
}

class ProfileUpdateError extends ProfileState {
  final UserModel user;
  final String message;
  const ProfileUpdateError(this.user, this.message);
}

class PasswordChanging extends ProfileState {
  final UserModel user;
  const PasswordChanging(this.user);
}

class PasswordChangeSuccess extends ProfileState {
  final UserModel user;
  const PasswordChangeSuccess(this.user);
}

class PasswordChangeError extends ProfileState {
  final UserModel user;
  final String message;
  const PasswordChangeError(this.user, this.message);
}
