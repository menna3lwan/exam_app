import 'package:flutter/material.dart';

import '../../../common/utils/validators.dart';
import '../../../common/widgets/app_button.dart';
import '../../../common/widgets/app_password_field.dart';
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

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onContinue() {
    if (_formKey.currentState?.validate() ?? false) {
      // Phase 2: dispatch resetPassword event to Cubit
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.login,
        (route) => false,
      );
    }
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
                  validator: Validators.password,
                ),
                const SizedBox(height: AppDimensions.lg),
                // ---- Confirm Password ----
                AppPasswordField(
                  label: 'Confirm password',
                  hintText: 'Confirm password',
                  controller: _confirmPasswordController,
                  textInputAction: TextInputAction.done,
                  validator: (v) =>
                      Validators.confirmPassword(v, _passwordController.text),
                  onFieldSubmitted: (_) => _onContinue(),
                ),
                const Spacer(),
                // ---- Continue button ----
                AppButton(
                  label: 'Continue',
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
