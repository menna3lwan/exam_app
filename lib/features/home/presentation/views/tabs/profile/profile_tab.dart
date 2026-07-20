import 'package:flutter/material.dart';

import '../../../../../../common/widgets/app_button.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_dimensions.dart';
import '../../../../../../core/theme/app_text_styles.dart';

/// Profile tab matching the Figma "Profile" frame.
///
/// Displays user info in read-only form fields with mock data.
/// Edit functionality is a future feature.
class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg),
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
            _ProfileField(label: 'User name', value: 'Mohamed_Ahmed123'),
            const SizedBox(height: AppDimensions.md),
            Row(
              children: [
                Expanded(
                  child: _ProfileField(
                    label: 'First name',
                    value: 'Mohamed',
                  ),
                ),
                const SizedBox(width: AppDimensions.md),
                Expanded(
                  child: _ProfileField(
                    label: 'Last name',
                    value: 'Ahmed',
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.md),
            _ProfileField(
              label: 'Email',
              value: 'Mohamed098@gmail.com',
            ),
            const SizedBox(height: AppDimensions.md),
            _ProfileField(
              label: 'Password',
              value: '••••••',
              trailing: GestureDetector(
                onTap: () {
                  // TODO: Navigate to change password screen
                },
                child: Text(
                  'Change',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.md),
            _ProfileField(
              label: 'Phone number',
              value: '1234567890987',
            ),

            const SizedBox(height: AppDimensions.xl),

            // ── Update button ──
            AppButton(
              label: 'Update',
              onPressed: () {
                // TODO: Navigate to edit profile (future feature)
              },
            ),

            const SizedBox(height: AppDimensions.xl),
          ],
        ),
      ),
    );
  }
}

/// Read-only profile field matching Figma outlined input style.
class _ProfileField extends StatelessWidget {
  final String label;
  final String value;
  final Widget? trailing;

  const _ProfileField({
    required this.label,
    required this.value,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
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
      child: Row(
        children: [
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodyLarge,
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
