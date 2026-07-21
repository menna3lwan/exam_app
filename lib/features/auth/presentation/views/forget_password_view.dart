import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/utils/app_snackbar.dart';
import '../../../../common/utils/validators.dart';
import '../../../../common/widgets/app_button.dart';
import '../../../../common/widgets/app_text_field.dart';
import '../../../../core/di/di.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/routing/route_arguments.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../cubits/forget_password/forget_password_cubit.dart';
import '../cubits/forget_password/forget_password_state.dart';

class ForgetPasswordView extends StatelessWidget {
  const ForgetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ForgetPasswordCubit>(),
      child: const _ForgetPasswordBody(),
    );
  }
}

class _ForgetPasswordBody extends StatefulWidget {
  const _ForgetPasswordBody();

  @override
  State<_ForgetPasswordBody> createState() => _ForgetPasswordBodyState();
}

class _ForgetPasswordBodyState extends State<_ForgetPasswordBody> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() => setState(() {}));
  }

  bool get _isButtonEnabled {
    final email = _emailController.text;
    if (email.isNotEmpty && Validators.email(email) != null) return false;
    return true;
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onContinue() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context
        .read<ForgetPasswordCubit>()
        .sendCode(email: _emailController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Password'),
      ),
      body: BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
        listener: (context, state) {
          switch (state) {
            case ForgetPasswordSuccess():
              AppSnackBar.showSuccess(
                  context, 'Verification code sent to your email');
              Navigator.pushNamed(
                context,
                AppRoutes.verificationCode,
                arguments: VerificationCodeArgs(
                  email: _emailController.text.trim(),
                ),
              );
            case ForgetPasswordError(:final message):
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
                      'Forget password',
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: AppColors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppDimensions.sm),
                    Text(
                      'Please enter your email associated to\nyour account',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.gray,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppDimensions.xl),
                    AppTextField(
                      label: 'Email',
                      hintText: 'Enter you email',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      validator: Validators.email,
                      onFieldSubmitted: (_) => _onContinue(),
                    ),
                    const SizedBox(height: AppDimensions.xxl),
                    AppButton(
                      label: 'Continue',
                      isLoading: state is ForgetPasswordLoading,
                      onPressed: _isButtonEnabled ? _onContinue : null,
                    ),
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
