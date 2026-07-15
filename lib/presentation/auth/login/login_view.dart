import 'package:flutter/material.dart';

import '../../../common/utils/app_snackbar.dart';
import '../../../common/utils/validators.dart';
import '../../../common/widgets/app_button.dart';
import '../../../common/widgets/app_password_field.dart';
import '../../../common/widgets/app_text_field.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocusNode = FocusNode();
  bool _rememberMe = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);

    // Phase 2: replace with Cubit call
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;
    setState(() => _isLoading = false);

    AppSnackBar.showSuccess(context, 'Login successful!');

    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Login'),
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
                const SizedBox(height: AppDimensions.lg),
                // ---- Email ----
                AppTextField(
                  label: 'Email',
                  hintText: 'Enter you email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: Validators.email,
                  onFieldSubmitted: (_) =>
                      _passwordFocusNode.requestFocus(),
                ),
                const SizedBox(height: AppDimensions.lg),
                // ---- Password ----
                AppPasswordField(
                  label: 'Password',
                  hintText: 'Enter you password',
                  controller: _passwordController,
                  focusNode: _passwordFocusNode,
                  textInputAction: TextInputAction.done,
                  validator: Validators.password,
                  onFieldSubmitted: (_) => _onLogin(),
                ),
                const SizedBox(height: AppDimensions.sm),
                // ---- Remember me + Forget password ----
                Row(
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: _rememberMe,
                        onChanged: (v) =>
                            setState(() => _rememberMe = v ?? false),
                        activeColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.gray),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.xs),
                    Text(
                      'Remember me',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.forgetPassword);
                      },
                      child: Text(
                        'Forget password?',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.black,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.xxl),
                // ---- Login button ----
                AppButton(
                  label: 'Login',
                  isLoading: _isLoading,
                  onPressed: _onLogin,
                ),
                const SizedBox(height: AppDimensions.md),
                // ---- Sign Up link ----
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.signUp);
                      },
                      child: Text(
                        'Sign up',
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
