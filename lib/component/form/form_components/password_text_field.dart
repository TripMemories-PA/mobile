import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../bloc/subscribe_bloc/subscribe_bloc.dart';
import '../../../constants/my_colors.dart';
import '../../../constants/string_constants.dart';
import '../../../utils/field_validator.dart';

class PasswordTextField extends HookWidget {
  const PasswordTextField({
    super.key,
    required this.passwordController,
    this.previousPasswordController,
  });

  final TextEditingController passwordController;
  final TextEditingController? previousPasswordController;

  @override
  Widget build(BuildContext context) {
    final hidePassword = useState(true);
    return TextFormField(
      textInputAction: TextInputAction.done,
      readOnly: context.read<SubscribeBloc>().state.loading,
      obscureText: hidePassword.value,
      decoration: InputDecoration(
        errorMaxLines: 4,
        hintText: StringConstants.password,
        suffixIcon: InkWell(
          child: Icon(
            hidePassword.value ? Icons.remove_red_eye : Icons.visibility_off,
            size: 20,
            color: MyColors.darkGrey,
          ),
          onTap: () {
            hidePassword.value = !hidePassword.value;
          },
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 8.0,
        ),
      ),
      validator: (value) => previousPasswordController != null
          ? FieldValidator.validateSamePassword(
              value,
              previousPasswordController?.text,
            )
          : FieldValidator.validatePassword(value),
      controller: passwordController,
    );
  }
}
