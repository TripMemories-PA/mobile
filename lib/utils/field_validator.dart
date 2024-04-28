import 'package:flutter/cupertino.dart';

@immutable
class FieldValidator {
  const FieldValidator._();

  static String? validateRequired(
    dynamic value,
  ) {
    if (value == null || value.isEmpty) {
      return 'Champs obligatoire';
    }
    return null;
  }

  static String? validatePassword(dynamic value) {
    if (value == null || value.isEmpty) {
      return 'Champs obligatoire';
    }

    final password = value.toString();

    if (password.length < 8 || password.length > 16) {
      return 'Votre mot de passe doit faire entre 8 et 16 caractères';
    }

    if (!password.contains(RegExp(r'[a-zA-Z]'))) {
      return 'Votre mot de passe doit contenir au moins une lettre';
    }

    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'Votre mot de passe doit contenir au moins un chiffre';
    }

    if (password.contains(RegExp(r'\s'))) {
      return 'Votre mot de passe ne peut pas contenir d\'espace';
    }

    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Votre mot de passe doit contenir au moins un caractère spécial';
    }

    return null;
  }

  static String? validateSamePassword(String password, String confirmPassword) {
    final String? valid = validateRequired(confirmPassword);
    if (valid != null) {
      return valid;
    }
    if (password != confirmPassword) {
      return 'Les mots de passe ne correspondent pas';
    }
    return null;
  }

  static String? validateEmail(String email) {
    if (email.isEmpty) {
      return 'Champs obligatoire';
    } else {
      final isValidEmail =
          RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(email);
      if (!isValidEmail) {
        return 'Adresse email invalide';
      }
      return null;
    }
  }
}
