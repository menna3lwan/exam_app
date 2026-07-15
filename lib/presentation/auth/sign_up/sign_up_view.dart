import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../common/utils/app_snackbar.dart';
import '../../../common/utils/validators.dart';
import '../../../common/widgets/app_button.dart';
import '../../../common/widgets/app_password_field.dart';
import '../../../common/widgets/app_text_field.dart';
import '../../../common/widgets/password_requirements.dart';
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

  // Focus nodes for field traversal
  final _firstNameFocus = FocusNode();
  final _lastNameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();
  final _phoneFocus = FocusNode();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Trigger rebuild when password changes so PasswordRequirements updates
    _passwordController.addListener(() => setState(() {}));
    // Trigger rebuild when confirm password or original password changes
    // so confirm-password validator re-evaluates live
    _confirmPasswordController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _firstNameFocus.dispose();
    _lastNameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    _phoneFocus.dispose();
    super.dispose();
  }

  Future<void> _onSignUp() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);

    // Phase 2: replace with Cubit call
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;
    setState(() => _isLoading = false);

    AppSnackBar.showSuccess(context, 'Account created successfully!');

    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.login);
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
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppDimensions.md),
                // ---- User name (full width) ----
                AppTextField(
                  label: 'User name',
                  hintText: 'Enter you user name',
                  controller: _usernameController,
                  textInputAction: TextInputAction.next,
                  validator: Validators.username,
                  onFieldSubmitted: (_) => _firstNameFocus.requestFocus(),
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
                        focusNode: _firstNameFocus,
                        textInputAction: TextInputAction.next,
                        validator: (v) => Validators.name(v, 'First name'),
                        onFieldSubmitted: (_) =>
                            _lastNameFocus.requestFocus(),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.md),
                    Expanded(
                      child: AppTextField(
                        label: 'Last name',
                        hintText: 'Enter last name',
                        controller: _lastNameController,
                        focusNode: _lastNameFocus,
                        textInputAction: TextInputAction.next,
                        validator: (v) => Validators.name(v, 'Last name'),
                        onFieldSubmitted: (_) => _emailFocus.requestFocus(),
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
                  focusNode: _emailFocus,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: Validators.email,
                  onFieldSubmitted: (_) => _passwordFocus.requestFocus(),
                ),
                const SizedBox(height: AppDimensions.lg),
                // ---- Password + Confirm password (side by side) ----
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AppPasswordField(
                        label: 'Password',
                        hintText: 'Enter password',
                        controller: _passwordController,
                        focusNode: _passwordFocus,
                        textInputAction: TextInputAction.next,
                        validator: Validators.password,
                        onFieldSubmitted: (_) =>
                            _confirmPasswordFocus.requestFocus(),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.md),
                    Expanded(
                      child: AppPasswordField(
                        label: 'Confirm password',
                        hintText: 'Confirm password',
                        controller: _confirmPasswordController,
                        focusNode: _confirmPasswordFocus,
                        textInputAction: TextInputAction.next,
                        validator: (v) => Validators.confirmPassword(
                            v, _passwordController.text),
                        onFieldSubmitted: (_) => _phoneFocus.requestFocus(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.sm),
                // ---- Password requirements checklist ----
                PasswordRequirements(password: _passwordController.text),
                const SizedBox(height: AppDimensions.lg),
                // ---- Phone number (full width) ----
                AppTextField(
                  label: 'Phone number',
                  hintText: 'e.g. 01XXXXXXXXX',
                  controller: _phoneController,
                  focusNode: _phoneFocus,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.done,
                  validator: Validators.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(11),
                  ],
                  onFieldSubmitted: (_) => _onSignUp(),
                ),
                const SizedBox(height: AppDimensions.xxl),
                // ---- Signup button ----
                AppButton(
                  label: 'Signup',
                  isLoading: _isLoading,
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
