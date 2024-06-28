import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../bloc/profile/profile_bloc.dart';
import '../../constants/my_colors.dart';
import '../../constants/string_constants.dart';
import '../../num_extensions.dart';
import '../../utils/field_validator.dart';
import '../bouncing_widget.dart';

class ModifyUserInfosForm extends HookWidget {
  ModifyUserInfosForm({
    super.key,
    required this.profileBloc,
  });

  final ProfileBloc profileBloc;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController =
        useTextEditingController(text: profileBloc.state.profile!.username);
    final TextEditingController lastName = useTextEditingController(
      text: profileBloc.state.profile?.lastname ?? '',
    );
    final TextEditingController firstNameController = useTextEditingController(
      text: profileBloc.state.profile?.firstname ?? '',
    );
    final TextEditingController emailController =
        useTextEditingController(text: profileBloc.state.profile!.email);
    return Form(
      key: formKey,
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
                hintText: StringConstants().username,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                prefixIcon: const Icon(Icons.person_outline),
              ),
              textAlignVertical: TextAlignVertical.center,
              validator: (value) => FieldValidator.validateRequired(
                value: value,
                minLenghtValue: 3,
              ),
              controller: usernameController,
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
                hintText: StringConstants().lastName,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                prefixIcon: const Icon(Icons.person_outline),
              ),
              textAlignVertical: TextAlignVertical.center,
              validator: (value) => FieldValidator.validateRequired(
                value: value,
                minLenghtValue: 3,
              ),
              controller: lastName,
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
                hintText: StringConstants().firstName,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                prefixIcon: const Icon(Icons.person_outline),
              ),
              textAlignVertical: TextAlignVertical.center,
              validator: (value) => FieldValidator.validateRequired(
                value: value,
                minLenghtValue: 3,
              ),
              controller: firstNameController,
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
                hintText: StringConstants().email,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                prefixIcon: const Icon(Icons.alternate_email),
              ),
              textAlignVertical: TextAlignVertical.center,
              validator: (value) => FieldValidator.validateEmail(value!),
              controller: emailController,
            ),
          ),
          15.ph,
          BouncingWidget(
            onTap: () async {
              if (formKey.currentState!.validate()) {
                FocusManager.instance.primaryFocus?.unfocus();
                profileBloc.add(
                  UpdateProfileEvent(
                    username: usernameController.text,
                    lastName: lastName.text,
                    firstName: firstNameController.text,
                    email: emailController.text,
                  ),
                );
              }
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
                  StringConstants().modifyInfos,
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
