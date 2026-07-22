/// Form field validators used across auth screens.
///
/// Returns null if valid, error message string if invalid.
/// Error messages match the Figma design spec.
///
/// Each validator is designed for live (per-keystroke) validation —
/// it returns the most specific failing rule so the user can fix one
/// thing at a time.
class Validators {
  Validators._();

  static String? required(String? value, [String fieldName = 'This field']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'This Email is not valid';
    }
    return null;
  }

  /// Full password validation — reports the first failing rule.
  /// For a real-time breakdown of all rules, use [PasswordRules].
  ///
  /// Matches the API's password regex (verified from Postman error response):
  /// `^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$`
  static String? password(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain an upper case letter';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain a lower case letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    if (!RegExp(r'[#?!@$%^&*-]').hasMatch(value)) {
      return 'Password must contain a special character';
    }
    return null;
  }

  static String? confirmPassword(String? value, String? password) {
    if (value == null || value.trim().isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Password not matched';
    }
    return null;
  }

  /// Egyptian mobile number: exactly 11 digits, prefix 010 / 011 / 012 / 015.
  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    final digits = value.trim();
    final egyptRegex = RegExp(r'^01[0125][0-9]{8}$');
    if (!egyptRegex.hasMatch(digits)) {
      return 'Enter a valid Egyptian number (e.g. 01XXXXXXXXX)';
    }
    return null;
  }

  static String? name(String? value, [String fieldName = 'Name']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    if (value.trim().length < 2) {
      return '$fieldName must be at least 2 characters';
    }
    return null;
  }

  static String? username(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username is required';
    }
    if (value.trim().length < 3) {
      return 'This user name is not valid';
    }
    return null;
  }
}

/// Granular password-rule checks for the real-time requirements widget.
/// Each method returns `true` when the rule is satisfied.
class PasswordRules {
  PasswordRules._();

  static bool hasMinLength(String value) => value.length >= 8;
  static bool hasUpperCase(String value) => RegExp(r'[A-Z]').hasMatch(value);
  static bool hasLowerCase(String value) => RegExp(r'[a-z]').hasMatch(value);
  static bool hasDigit(String value) => RegExp(r'[0-9]').hasMatch(value);
  static bool hasSpecialChar(String value) =>
      RegExp(r'[#?!@$%^&*-]').hasMatch(value);

  /// All rules pass.
  static bool isValid(String value) =>
      hasMinLength(value) &&
      hasUpperCase(value) &&
      hasLowerCase(value) &&
      hasDigit(value) &&
      hasSpecialChar(value);
}
