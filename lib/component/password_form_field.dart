import 'package:flutter/material.dart';

import '../../../utils/field_validator.dart';

class PasswordFormField extends StatefulWidget {
  const PasswordFormField({
    super.key,
    required this.passwordController,
    required this.needPasswordControl,
  });

  final TextEditingController passwordController;
  final bool needPasswordControl;

  @override
  State<PasswordFormField> createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.passwordController,
      obscureText: hidePassword,
      decoration: InputDecoration(
        hintText: 'Mot de passe',
        prefixIcon: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: Icon(Icons.lock_outline),
        ),
        suffixIcon: IconButton(
          icon: Icon(hidePassword ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(
              () {
                hidePassword = !hidePassword;
              },
            );
          },
        ),
      ),
      keyboardType: TextInputType.visiblePassword,
      validator: (value) => widget.needPasswordControl
          ? FieldValidator.validatePassword(value)
          : FieldValidator.validateRequired(value),
    );
  }
}
