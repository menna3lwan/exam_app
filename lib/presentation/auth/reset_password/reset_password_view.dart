import 'package:flutter/material.dart';

import '../../../common/utils/app_snackbar.dart';
import '../../../common/utils/validators.dart';
import '../../../common/widgets/app_button.dart';
import '../../../common/widgets/app_password_field.dart';
import '../../../common/widgets/password_requirements.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _confirmPasswordFocus = FocusNode();
  String? _email;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Rebuild for live PasswordRequirements + confirm-password re-validation
    _passwordController.addListener(() => setState(() {}));
    _confirmPasswordController.addListener(() => setState(() {}));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _email ??= ModalRoute.of(context)?.settings.arguments as String?;
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  Future<void> _onContinue() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);

    // Phase 2: replace with Cubit call using _email + newPassword
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;
    setState(() => _isLoading = false);

    AppSnackBar.showSuccess(context, 'Password reset successful!');

    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Password'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.lg,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppDimensions.lg),
                // ---- Title ----
                Text(
                  'Reset password',
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: AppColors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.sm),
                // ---- Subtitle (password requirements) ----
                Text(
                  'Password must not be empty and must contain\n6 characters with upper case letter and one\nnumber at least',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.gray,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.xl),
                // ---- New Password ----
                AppPasswordField(
                  label: 'New password',
                  hintText: 'Enter you password',
                  controller: _passwordController,
                  textInputAction: TextInputAction.next,
                  validator: Validators.password,
                  onFieldSubmitted: (_) =>
                      _confirmPasswordFocus.requestFocus(),
                ),
                // ---- Password requirements checklist (visible once user starts typing) ----
                if (_passwordController.text.isNotEmpty) ...[
                  const SizedBox(height: AppDimensions.sm),
                  PasswordRequirements(password: _passwordController.text),
                ],
                const SizedBox(height: AppDimensions.lg),
                // ---- Confirm Password ----
                AppPasswordField(
                  label: 'Confirm password',
                  hintText: 'Confirm password',
                  controller: _confirmPasswordController,
                  focusNode: _confirmPasswordFocus,
                  textInputAction: TextInputAction.done,
                  validator: (v) =>
                      Validators.confirmPassword(v, _passwordController.text),
                  onFieldSubmitted: (_) => _onContinue(),
                ),
                // ---- Live confirm-password match indicator ----
                if (_confirmPasswordController.text.isNotEmpty) ...[
                  const SizedBox(height: AppDimensions.xs),
                  Row(
                    children: [
                      Icon(
                        _confirmPasswordController.text ==
                                _passwordController.text
                            ? Icons.check_circle
                            : Icons.cancel,
                        size: 16,
                        color: _confirmPasswordController.text ==
                                _passwordController.text
                            ? AppColors.success
                            : AppColors.error,
                      ),
                      const SizedBox(width: AppDimensions.sm),
                      Text(
                        _confirmPasswordController.text ==
                                _passwordController.text
                            ? 'Passwords match'
                            : 'Passwords do not match',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: _confirmPasswordController.text ==
                                  _passwordController.text
                              ? AppColors.success
                              : AppColors.error,
                        ),
                      ),
                    ],
                  ),
                ],
                const Spacer(),
                // ---- Continue button ----
                AppButton(
                  label: 'Continue',
                  isLoading: _isLoading,
                  onPressed: _onContinue,
                ),
                const SizedBox(height: AppDimensions.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
