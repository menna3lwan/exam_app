import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/utils/app_snackbar.dart';
import '../../../../common/utils/validators.dart';
import '../../../../common/widgets/app_button.dart';
import '../../../../common/widgets/app_password_field.dart';
import '../../../../common/widgets/password_requirements.dart';
import '../../../../core/di/di.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/routing/route_arguments.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../cubits/reset_password/reset_password_cubit.dart';
import '../cubits/reset_password/reset_password_state.dart';

class ResetPasswordView extends StatelessWidget {
  const ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ResetPasswordCubit>(),
      child: const _ResetPasswordBody(),
    );
  }
}

class _ResetPasswordBody extends StatefulWidget {
  const _ResetPasswordBody();

  @override
  State<_ResetPasswordBody> createState() => _ResetPasswordBodyState();
}

class _ResetPasswordBodyState extends State<_ResetPasswordBody> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _confirmPasswordFocus = FocusNode();
  String? _email;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() => setState(() {}));
    _confirmPasswordController.addListener(() => setState(() {}));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_email == null) {
      final args =
          ModalRoute.of(context)?.settings.arguments as ResetPasswordArgs?;
      _email = args?.email;
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  void _onContinue() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final email = _email;
    if (email == null) return;
    context.read<ResetPasswordCubit>().resetPassword(
          email: email,
          newPassword: _passwordController.text,
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
      body: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
        listener: (context, state) {
          switch (state) {
            case ResetPasswordSuccess():
              AppSnackBar.showSuccess(context, 'Password reset successful!');
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                (route) => false,
              );
            case ResetPasswordError(:final message):
              AppSnackBar.showError(context, message);
            case _:
              break;
          }
        },
        builder: (context, state) {
          return SafeArea(
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
                    Text(
                      'Reset password',
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: AppColors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppDimensions.sm),
                    Text(
                      'Password must not be empty and must contain\n6 characters with upper case letter and one\nnumber at least',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.gray,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppDimensions.xl),
                    AppPasswordField(
                      label: 'New password',
                      hintText: 'Enter you password',
                      controller: _passwordController,
                      textInputAction: TextInputAction.next,
                      validator: Validators.password,
                      onFieldSubmitted: (_) =>
                          _confirmPasswordFocus.requestFocus(),
                    ),
                    if (_passwordController.text.isNotEmpty) ...[
                      const SizedBox(height: AppDimensions.sm),
                      PasswordRequirements(
                          password: _passwordController.text),
                    ],
                    const SizedBox(height: AppDimensions.lg),
                    AppPasswordField(
                      label: 'Confirm password',
                      hintText: 'Confirm password',
                      controller: _confirmPasswordController,
                      focusNode: _confirmPasswordFocus,
                      textInputAction: TextInputAction.done,
                      validator: (v) => Validators.confirmPassword(
                          v, _passwordController.text),
                      onFieldSubmitted: (_) => _onContinue(),
                    ),
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
                    AppButton(
                      label: 'Continue',
                      isLoading: state is ResetPasswordLoading,
                      onPressed: _onContinue,
                    ),
                    const SizedBox(height: AppDimensions.lg),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
