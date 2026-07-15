import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Reusable text field matching the Figma design:
/// - Floating outlined label (Material `labelText`) that sits in the border
/// - Gray outline border, primary blue on focus, red on error
/// - Inter 16px input text, 13px floating label
/// - Inline error message below the field
class AppTextField extends StatelessWidget {
  final String? label;
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final bool readOnly;
  final int maxLines;
  final FocusNode? focusNode;
  final bool autofocus;
  final List<TextInputFormatter>? inputFormatters;

  const AppTextField({
    super.key,
    this.label,
    this.hintText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.readOnly = false,
    this.maxLines = 1,
    this.focusNode,
    this.autofocus = false,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      readOnly: readOnly,
      maxLines: maxLines,
      focusNode: focusNode,
      autofocus: autofocus,
      inputFormatters: inputFormatters,
      style: AppTextStyles.bodyLarge.copyWith(color: AppColors.black),
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }
}
