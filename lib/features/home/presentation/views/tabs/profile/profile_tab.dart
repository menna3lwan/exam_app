import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/utils/app_snackbar.dart';
import '../../../../../../common/utils/validators.dart';
import '../../../../../../common/widgets/app_button.dart';
import '../../../../../../core/di/di.dart';
import '../../../../../../core/routing/app_routes.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_dimensions.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../features/auth/data/models/user_model.dart';
import '../../../../../../features/auth/presentation/cubits/logout/logout_cubit.dart';
import '../../../../../../features/auth/presentation/cubits/logout/logout_state.dart';
import '../../../../../../features/auth/presentation/cubits/profile/profile_cubit.dart';
import '../../../../../../features/auth/presentation/cubits/profile/profile_state.dart';

/// Profile tab — loads user data from GET /auth/profileData,
/// supports editing via PUT /auth/editProfile, password
/// change via PATCH /auth/changePassword, and logout.
class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<ProfileCubit>()..loadProfile(),
        ),
        BlocProvider(
          create: (_) => getIt<LogoutCubit>(),
        ),
      ],
      child: const _ProfileContent(),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent();

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ProfileCubit, ProfileState>(
          listenWhen: (prev, curr) =>
              curr is ProfileUpdateSuccess ||
              curr is ProfileUpdateError,
          listener: (context, state) {
            switch (state) {
              case ProfileUpdateSuccess(:final message):
                AppSnackBar.showSuccess(context, message);
              case ProfileUpdateError(:final message):
                AppSnackBar.showError(context, message);
              default:
                break;
            }
          },
        ),
        BlocListener<LogoutCubit, LogoutState>(
          listener: (context, state) {
            if (state is LogoutSuccess) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoutes.login,
                (_) => false,
              );
            }
          },
        ),
      ],
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          return switch (state) {
            ProfileInitial() || ProfileLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
            ProfileError(:final message) => _buildErrorState(context, message),
            _ => _ProfileForm(user: _extractUser(state)!),
          };
        },
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.cloud_off_outlined, size: 64, color: AppColors.gray),
          const SizedBox(height: AppDimensions.md),
          Text(
            'Could not load profile',
            style: AppTextStyles.bodyLarge.copyWith(color: AppColors.gray),
          ),
          const SizedBox(height: AppDimensions.lg),
          SizedBox(
            width: 140,
            child: OutlinedButton(
              onPressed: () => context.read<ProfileCubit>().loadProfile(),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
              ),
              child: const Text('Retry'),
            ),
          ),
        ],
      ),
    );
  }

  UserModel? _extractUser(ProfileState state) => switch (state) {
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

class _ProfileForm extends StatefulWidget {
  final UserModel user;
  const _ProfileForm({required this.user});

  @override
  State<_ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<_ProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _usernameCtrl;
  late final TextEditingController _firstNameCtrl;
  late final TextEditingController _lastNameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;

  @override
  void initState() {
    super.initState();
    _usernameCtrl = TextEditingController(text: widget.user.username);
    _firstNameCtrl = TextEditingController(text: widget.user.firstName);
    _lastNameCtrl = TextEditingController(text: widget.user.lastName);
    _emailCtrl = TextEditingController(text: widget.user.email);
    _phoneCtrl = TextEditingController(text: widget.user.phone);
  }

  @override
  void didUpdateWidget(covariant _ProfileForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync controllers when user data actually changes (e.g. after successful update).
    // UserModel now implements == so this only fires on real data changes.
    if (oldWidget.user != widget.user) {
      _usernameCtrl.text = widget.user.username;
      _firstNameCtrl.text = widget.user.firstName;
      _lastNameCtrl.text = widget.user.lastName;
      _emailCtrl.text = widget.user.email;
      _phoneCtrl.text = widget.user.phone;
    }
  }

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isUpdating = context.select<ProfileCubit, bool>(
      (cubit) => cubit.state is ProfileUpdating,
    );
    final isLoggingOut = context.select<LogoutCubit, bool>(
      (cubit) => cubit.state is LogoutLoading,
    );

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () => context.read<ProfileCubit>().loadProfile(),
        color: AppColors.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppDimensions.lg),
                Text(
                  'Profile',
                  style: AppTextStyles.headlineSmall.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppDimensions.lg),

                // ── Avatar ──
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.lightBlue,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: AppColors.gray,
                    ),
                  ),
                ),

                const SizedBox(height: AppDimensions.lg),

                // ── Form fields ──
                _buildTextField(
                  controller: _usernameCtrl,
                  label: 'User name',
                  validator: (v) => Validators.username(v),
                ),
                const SizedBox(height: AppDimensions.md),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _firstNameCtrl,
                        label: 'First name',
                        validator: (v) => Validators.name(v, 'First name'),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.md),
                    Expanded(
                      child: _buildTextField(
                        controller: _lastNameCtrl,
                        label: 'Last name',
                        validator: (v) => Validators.name(v, 'Last name'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.md),
                _buildTextField(
                  controller: _emailCtrl,
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => Validators.email(v),
                ),
                const SizedBox(height: AppDimensions.md),
                _buildPasswordField(context),
                const SizedBox(height: AppDimensions.md),
                _buildTextField(
                  controller: _phoneCtrl,
                  label: 'Phone number',
                  keyboardType: TextInputType.phone,
                  validator: (v) => Validators.phone(v),
                ),

                const SizedBox(height: AppDimensions.xl),

                // ── Update button ──
                AppButton(
                  label: 'Update',
                  isLoading: isUpdating,
                  onPressed: isUpdating ? null : _onUpdate,
                ),

                const SizedBox(height: AppDimensions.md),

                // ── Logout button ──
                AppButton(
                  label: 'Logout',
                  isOutlined: true,
                  isLoading: isLoggingOut,
                  onPressed: isLoggingOut ? null : () => _onLogout(context),
                ),

                const SizedBox(height: AppDimensions.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      style: AppTextStyles.bodyLarge,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.gray),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.sm),
          borderSide: BorderSide(color: AppColors.gray),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.sm),
          borderSide: BorderSide(color: AppColors.gray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.sm),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.sm),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.sm),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.md,
          vertical: AppDimensions.sm,
        ),
      ),
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.gray),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.sm),
          borderSide: BorderSide(color: AppColors.gray),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.sm),
          borderSide: BorderSide(color: AppColors.gray),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.md,
          vertical: AppDimensions.sm,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text('••••••', style: AppTextStyles.bodyLarge),
          ),
          InkWell(
            onTap: () => _showChangePasswordSheet(context),
            borderRadius: BorderRadius.circular(AppDimensions.xs),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.xs,
                vertical: 2,
              ),
              child: Text(
                'Change',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onUpdate() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    context.read<ProfileCubit>().updateProfile(
          username: _usernameCtrl.text.trim(),
          firstName: _firstNameCtrl.text.trim(),
          lastName: _lastNameCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
          phone: _phoneCtrl.text.trim(),
        );
  }

  void _onLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<LogoutCubit>().logout();
            },
            child: Text(
              'Logout',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordSheet(BuildContext context) {
    final cubit = context.read<ProfileCubit>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.md),
        ),
      ),
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: const _ChangePasswordSheet(),
      ),
    );
  }
}

class _ChangePasswordSheet extends StatefulWidget {
  const _ChangePasswordSheet();

  @override
  State<_ChangePasswordSheet> createState() => _ChangePasswordSheetState();
}

class _ChangePasswordSheetState extends State<_ChangePasswordSheet> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordCtrl = TextEditingController();
  final _newPasswordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();

  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _oldPasswordCtrl.dispose();
    _newPasswordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isChanging = context.select<ProfileCubit, bool>(
      (cubit) => cubit.state is PasswordChanging,
    );

    return MultiBlocListener(
      listeners: [
        BlocListener<ProfileCubit, ProfileState>(
          listenWhen: (_, current) => current is PasswordChangeSuccess,
          listener: (context, _) {
            AppSnackBar.showSuccess(context, 'Password changed successfully');
            Navigator.of(context).pop();
          },
        ),
        BlocListener<ProfileCubit, ProfileState>(
          listenWhen: (_, current) => current is PasswordChangeError,
          listener: (context, state) {
            if (state is PasswordChangeError) {
              AppSnackBar.showError(context, state.message);
            }
          },
        ),
      ],
      child: Padding(
        padding: EdgeInsets.only(
          left: AppDimensions.lg,
          right: AppDimensions.lg,
          top: AppDimensions.sm,
          bottom: MediaQuery.of(context).viewInsets.bottom + AppDimensions.lg,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: AppDimensions.md),
                  decoration: BoxDecoration(
                    color: AppColors.gray.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                'Change Password',
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppDimensions.lg),
              _buildPasswordField(
                controller: _oldPasswordCtrl,
                label: 'Current Password',
                obscure: _obscureOld,
                onToggle: () => setState(() => _obscureOld = !_obscureOld),
                validator: (v) => Validators.required(v, 'Current password'),
              ),
              const SizedBox(height: AppDimensions.md),
              _buildPasswordField(
                controller: _newPasswordCtrl,
                label: 'New Password',
                obscure: _obscureNew,
                onToggle: () => setState(() => _obscureNew = !_obscureNew),
                validator: (v) => Validators.password(v),
              ),
              const SizedBox(height: AppDimensions.md),
              _buildPasswordField(
                controller: _confirmPasswordCtrl,
                label: 'Confirm Password',
                obscure: _obscureConfirm,
                onToggle: () =>
                    setState(() => _obscureConfirm = !_obscureConfirm),
                validator: (v) => Validators.confirmPassword(
                  v,
                  _newPasswordCtrl.text,
                ),
              ),
              const SizedBox(height: AppDimensions.xl),
              AppButton(
                label: 'Change Password',
                isLoading: isChanging,
                onPressed: isChanging ? null : _onSubmit,
              ),
              const SizedBox(height: AppDimensions.md),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback onToggle,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      style: AppTextStyles.bodyLarge,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.gray),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.sm),
          borderSide: BorderSide(color: AppColors.gray),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.sm),
          borderSide: BorderSide(color: AppColors.gray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.sm),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.sm),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.sm),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.md,
          vertical: AppDimensions.sm,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off : Icons.visibility,
            color: AppColors.gray,
          ),
          onPressed: onToggle,
        ),
      ),
    );
  }

  void _onSubmit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    context.read<ProfileCubit>().changePassword(
          oldPassword: _oldPasswordCtrl.text,
          newPassword: _newPasswordCtrl.text,
          confirmPassword: _confirmPasswordCtrl.text,
        );
  }
}
