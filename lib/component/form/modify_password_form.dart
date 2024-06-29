import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../bloc/profile/profile_bloc.dart';
import '../../constants/my_colors.dart';
import '../../constants/string_constants.dart';
import '../../num_extensions.dart';
import '../../utils/field_validator.dart';
import '../bouncing_widget.dart';

class UpdatePasswordForm extends HookWidget {
  const UpdatePasswordForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController passwordController = useTextEditingController();
    final TextEditingController confirmPasswordController =
        useTextEditingController();
    return Form(
      child: Column(
        children: [
          Container(
            height: 45,
            decoration: ShapeDecoration(
              color: MyColors.lightGrey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: StringConstants().password,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: InkWell(
                  child: const Icon(Icons.remove_red_eye_outlined),
                  onTap: () {},
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
              color: MyColors.lightGrey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: StringConstants().confirmPassword,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                prefixIcon: const Icon(Icons.lock_outline),
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
              context.read<ProfileBloc>().add(
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
