import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/utils/app_snackbar.dart';
import '../../../../core/di/di.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/routing/route_arguments.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../cubits/verify_code/verify_code_cubit.dart';
import '../cubits/verify_code/verify_code_state.dart';

class VerificationCodeView extends StatelessWidget {
  const VerificationCodeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<VerifyCodeCubit>(),
      child: const _VerificationCodeBody(),
    );
  }
}

class _VerificationCodeBody extends StatefulWidget {
  const _VerificationCodeBody();

  @override
  State<_VerificationCodeBody> createState() => _VerificationCodeBodyState();
}

class _VerificationCodeBodyState extends State<_VerificationCodeBody> {
  static const int _codeLength = 4;
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;
  String? _email;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(_codeLength, (_) => TextEditingController());
    _focusNodes = List.generate(_codeLength, (_) => FocusNode());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_email == null) {
      final args =
          ModalRoute.of(context)?.settings.arguments as VerificationCodeArgs?;
      _email = args?.email;
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _code => _controllers.map((c) => c.text).join();

  bool get _isCodeComplete => _code.length == _codeLength;

  void _onVerify() {
    final email = _email;
    if (!_isCodeComplete || email == null) return;
    context.read<VerifyCodeCubit>().verify(email: email, code: _code);
  }

  void _onResendCode() {
    final email = _email;
    if (email == null) return;
    context.read<VerifyCodeCubit>().resendCode(email: email);
  }

  void _onDigitChanged(int index, String value) {
    if (_hasError) setState(() => _hasError = false);
    if (value.length == 1 && index < _codeLength - 1) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    setState(() {});
    if (_isCodeComplete) _onVerify();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Password'),
      ),
      body: BlocConsumer<VerifyCodeCubit, VerifyCodeState>(
        listener: (context, state) {
          switch (state) {
            case VerifyCodeSuccess():
              AppSnackBar.showSuccess(context, 'Code verified successfully');
              Navigator.pushNamed(
                context,
                AppRoutes.resetPassword,
                arguments: ResetPasswordArgs(email: _email ?? ''),
              );
            case VerifyCodeResent():
              AppSnackBar.showSuccess(context, 'Verification code resent');
            case VerifyCodeError(:final message):
              setState(() => _hasError = true);
              AppSnackBar.showError(context, message);
            case _:
              break;
          }
        },
        builder: (context, state) {
          final isVerifying = state is VerifyCodeLoading;

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppDimensions.lg),
                  Text(
                    'Email verification',
                    style: AppTextStyles.headlineSmall.copyWith(
                      color: AppColors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppDimensions.sm),
                  Text(
                    'Please enter your code that send to your\nemail address',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.gray,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppDimensions.xl),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      _codeLength,
                      (index) => _OtpBox(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        hasError: _hasError,
                        onChanged: (value) => _onDigitChanged(index, value),
                      ),
                    ),
                  ),
                  if (_hasError) ...[
                    const SizedBox(height: AppDimensions.sm),
                    Text(
                      'Invalid verification code',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: AppDimensions.lg),
                  if (isVerifying)
                    const Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  if (!isVerifying)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Didn't receive code? ",
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.black,
                          ),
                        ),
                        GestureDetector(
                          onTap: _onResendCode,
                          child: Text(
                            'Resend',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.primary,
                              decoration: TextDecoration.underline,
                              decorationColor: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool hasError;
  final ValueChanged<String> onChanged;

  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.hasError,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final boxSize = (screenWidth - 48 - 48) / 4;

    return SizedBox(
      width: boxSize,
      height: boxSize,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: AppTextStyles.headlineMedium.copyWith(color: AppColors.black),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          counterText: '',
          contentPadding: EdgeInsets.zero,
          filled: true,
          fillColor: AppColors.lightBlue,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: hasError
                ? const BorderSide(color: AppColors.error, width: 1.5)
                : BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: AppColors.primary,
              width: 1.5,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: AppColors.error,
              width: 1.5,
            ),
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
