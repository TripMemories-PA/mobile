import 'package:flutter/cupertino.dart';

@immutable
class FieldValidator {
  const FieldValidator._();

  static String? validateRequired({
    dynamic value,
    int? minLenghtValue,
  }) {
    if (value == null || value.isEmpty) {
      return 'Champs obligatoire';
    }

    if (minLenghtValue != null && value.length < minLenghtValue) {
      return 'Le champ doit contenir au moins $minLenghtValue caractères';
    }
    return null;
  }

  static String? validatePassword(dynamic value) {
    if (value == null || value.isEmpty) {
      return 'Champs obligatoire';
    }

    final password = value.toString();

    const String phrase = r'''
  Pour un mot de passe valide, assurez-vous qu'il contienne entre 8 et 16 caractères, au moins une lettre, une majuscule, au moins un chiffre, aucun espace, et au moins un caractère spécial parmi !@#$%^&*(),.?":{}|<>.
''';

    if (password.length < 8 ||
        password.length > 16 ||
        !password.contains(RegExp(r'[a-zA-Z]')) ||
        !password.contains(RegExp(r'[0-9]')) ||
        password.contains(RegExp(r'\s')) ||
        !password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return phrase;
    }

    return null;
  }

  static String? validateSamePassword(
      dynamic password, dynamic confirmPassword) {
    final String? valid = validateRequired(value: confirmPassword);
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
