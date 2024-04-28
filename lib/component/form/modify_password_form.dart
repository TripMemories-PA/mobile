import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../bloc/profile/profile_bloc.dart';
import '../../constants/my_colors.dart';
import '../../num_extensions.dart';
import '../../utils/field_validator.dart';

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
                hintText: 'Mot de passe',
                border: InputBorder.none,
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: InkWell(
                  child: const Icon(Icons.remove_red_eye_outlined),
                  onTap: () {},
                ),
              ),
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
              decoration: const InputDecoration(
                hintText: 'Confirmation de mot de passe',
                border: InputBorder.none,
                prefixIcon: Icon(Icons.lock_outline),
              ),
              validator: (value) => FieldValidator.validateSamePassword(
                value!,
                passwordController.text,
              ),
              controller: confirmPasswordController,
            ),
          ),
          15.ph,
          InkWell(
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
                color: MyColors.success,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Center(
                child: Text(
                  'Modifier le mot de passe',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
