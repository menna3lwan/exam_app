import 'package:flutter/material.dart';

import '../../../common/utils/validators.dart';
import '../../../common/widgets/app_button.dart';
import '../../../common/widgets/app_password_field.dart';
import '../../../common/widgets/app_text_field.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onSignUp() {
    if (_formKey.currentState?.validate() ?? false) {
      // Phase 2: dispatch sign-up event to Cubit
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Sign up'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.lg,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppDimensions.md),
                // ---- User name (full width) ----
                AppTextField(
                  label: 'User name',
                  hintText: 'Enter you user name',
                  controller: _usernameController,
                  validator: Validators.username,
                ),
                const SizedBox(height: AppDimensions.lg),
                // ---- First name + Last name (side by side) ----
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: 'First name',
                        hintText: 'Enter first name',
                        controller: _firstNameController,
                        validator: (v) => Validators.name(v, 'First name'),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.md),
                    Expanded(
                      child: AppTextField(
                        label: 'Last name',
                        hintText: 'Enter last name',
                        controller: _lastNameController,
                        validator: (v) => Validators.name(v, 'Last name'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.lg),
                // ---- Email (full width) ----
                AppTextField(
                  label: 'Email',
                  hintText: 'Enter you email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.email,
                ),
                const SizedBox(height: AppDimensions.lg),
                // ---- Password + Confirm password (side by side) ----
                Row(
                  children: [
                    Expanded(
                      child: AppPasswordField(
                        label: 'Password',
                        hintText: 'Enter password',
                        controller: _passwordController,
                        validator: Validators.password,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.md),
                    Expanded(
                      child: AppPasswordField(
                        label: 'Confirm password',
                        hintText: 'Confirm password',
                        controller: _confirmPasswordController,
                        validator: (v) => Validators.confirmPassword(
                            v, _passwordController.text),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.lg),
                // ---- Phone number (full width) ----
                AppTextField(
                  label: 'Phone number',
                  hintText: 'Enter phone number',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.done,
                  validator: Validators.phone,
                ),
                const SizedBox(height: AppDimensions.xxl),
                // ---- Signup button ----
                AppButton(
                  label: 'Signup',
                  onPressed: _onSignUp,
                ),
                const SizedBox(height: AppDimensions.md),
                // ---- Login link ----
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        'Login',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primary,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
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
