import 'package:flutter/cupertino.dart';

import '../constants/string_constants.dart';

@immutable
class FieldValidator {
  const FieldValidator._();

  static String? validateRequired({
    dynamic value,
    int? minLenghtValue,
  }) {
    if (value == null || value.isEmpty) {
      return StringConstants().requiredField;
    }

    if (minLenghtValue != null && value.length < minLenghtValue) {
      return '${StringConstants().fieldMustContainsAtLeast} $minLenghtValue ${StringConstants().characters}';
    }
    return null;
  }

  static String? validatePassword(dynamic value) {
    if (value == null || value.isEmpty) {
      return StringConstants().requiredField;
    }

    final password = value.toString();

    final String phrase = StringConstants().passwordValidator;

    if (password.length < 8 ||
        password.length > 16 ||
        !password.contains(RegExp(r'[a-z]')) ||
        !password.contains(RegExp(r'[A-Z]')) ||
        !password.contains(RegExp(r'[0-9]')) ||
        password.contains(RegExp(r'\s')) ||
        !password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return phrase;
    }

    return null;
  }

  static String? validateSamePassword(
    dynamic password,
    dynamic confirmPassword,
  ) {
    final String? valid = validateRequired(value: confirmPassword);
    if (valid != null) {
      return valid;
    }
    if (password != confirmPassword) {
      return StringConstants().passwordsDoNotMatch;
    }
    return null;
  }

  static String? validateEmail(String email) {
    if (email.isEmpty) {
      return StringConstants().requiredField;
    } else {
      final isValidEmail =
          RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(email);
      if (!isValidEmail) {
        return StringConstants().invalidEmail;
      }
      return null;
    }
  }
}
