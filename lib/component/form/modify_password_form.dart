import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../bloc/profile/profile_bloc.dart';
import '../../constants/my_colors.dart';
import '../../constants/string_constants.dart';
import '../../num_extensions.dart';
import '../../utils/field_validator.dart';
import '../../utils/messenger.dart';
import '../bouncing_widget.dart';

class UpdatePasswordForm extends HookWidget {
  const UpdatePasswordForm({
    super.key,
    required this.profileBloc,
  });

  final ProfileBloc profileBloc;

  @override
  Widget build(BuildContext context) {
    final TextEditingController passwordController = useTextEditingController();
    final TextEditingController confirmPasswordController =
        useTextEditingController();
    final hidePassword = useState<bool>(true);
    final hideConfirmPassword = useState<bool>(true);
    return Form(
      child: Column(
        children: [
          Container(
            height: 45,
            decoration: ShapeDecoration(
              color: Theme.of(context).colorScheme.tertiary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: TextFormField(
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.done,
              obscureText: hidePassword.value,
              decoration: InputDecoration(
                hintText: StringConstants().password,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: InkWell(
                  child: const Icon(Icons.remove_red_eye_outlined),
                  onTap: () {
                    hidePassword.value = !hidePassword.value;
                  },
                ),
              ),
              textAlignVertical: TextAlignVertical.center,
              validator: (value) => FieldValidator.validatePassword(value),
              controller: passwordController,
            ),
          ),
          15.ph,
          Container(
            height: 45,
            decoration: ShapeDecoration(
              color: Theme.of(context).colorScheme.tertiary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: TextFormField(
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.done,
              obscureText: hideConfirmPassword.value,
              decoration: InputDecoration(
                hintText: StringConstants().confirmPassword,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: InkWell(
                  child: const Icon(Icons.remove_red_eye_outlined),
                  onTap: () {
                    hideConfirmPassword.value = !hideConfirmPassword.value;
                  },
                ),
              ),
              textAlignVertical: TextAlignVertical.center,
              validator: (value) => FieldValidator.validateSamePassword(
                value,
                passwordController.text,
              ),
              controller: confirmPasswordController,
            ),
          ),
          15.ph,
          BouncingWidget(
            onTap: () async {
              if (passwordController.text != confirmPasswordController.text) {
                Messenger.showSnackBarError(
                  StringConstants().passwordsDoNotMatch,
                );
                return;
              }
              profileBloc.add(
                UpdatePasswordEvent(
                  passwordController.text,
                ),
              );
            },
            child: Container(
              height: 45,
              decoration: ShapeDecoration(
                color: MyColors.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Center(
                child: Text(
                  StringConstants().updatePassword,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
