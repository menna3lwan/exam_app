import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/utils/validators.dart';
import '../../../../../../common/widgets/app_button.dart';
import '../../../../../../core/di/di.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_dimensions.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../features/auth/data/models/user_model.dart';
import '../../../../../../features/auth/presentation/cubits/profile/profile_cubit.dart';
import '../../../../../../features/auth/presentation/cubits/profile/profile_state.dart';

/// Profile tab — loads user data from GET /auth/profileData,
/// supports editing via PUT /auth/editProfile and password
/// change via PATCH /auth/changePassword.
class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProfileCubit>()..loadProfile(),
      child: const _ProfileContent(),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        switch (state) {
          case ProfileUpdateSuccess(:final message):
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: Colors.green,
              ),
            );
          case ProfileUpdateError(:final message):
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: Colors.red,
              ),
            );
          case PasswordChangeSuccess():
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Password changed successfully'),
                backgroundColor: Colors.green,
              ),
            );
          case PasswordChangeError(:final message):
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: Colors.red,
              ),
            );
          default:
            break;
        }
      },
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
    // Sync controllers when user data changes (e.g. after successful update).
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

    return SafeArea(
      child: SingleChildScrollView(
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
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.lightBlue,
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: AppColors.gray,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
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

              const SizedBox(height: AppDimensions.xl),
            ],
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
          GestureDetector(
            onTap: () => _showChangePasswordSheet(context),
            child: Text(
              'Change',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.primary,
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

    return BlocListener<ProfileCubit, ProfileState>(
      listenWhen: (_, current) => current is PasswordChangeSuccess,
      listener: (context, _) => Navigator.of(context).pop(),
      child: Padding(
        padding: EdgeInsets.only(
          left: AppDimensions.lg,
          right: AppDimensions.lg,
          top: AppDimensions.lg,
          bottom: MediaQuery.of(context).viewInsets.bottom + AppDimensions.lg,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
