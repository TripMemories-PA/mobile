import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../bloc/profile/profile_bloc.dart';
import '../../constants/my_colors.dart';
import '../../num_extensions.dart';
import '../../object/profile/profile.dart';
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
    final TextEditingController usernameController = useTextEditingController();
    usernameController.text = profileBloc.state.profile!.username;
    final TextEditingController lastName = useTextEditingController();
    lastName.text = profileBloc.state.profile?.lastname ?? '';
    final TextEditingController firstNameController =
        useTextEditingController();
    firstNameController.text = profileBloc.state.profile?.firstname ?? '';
    final TextEditingController emailController = useTextEditingController();
    emailController.text = profileBloc.state.profile!.email;
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
              decoration: const InputDecoration(
                hintText: "Nom d'utilisateur",
                border: InputBorder.none,
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: (value) => FieldValidator.validateRequired(value),
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
              decoration: const InputDecoration(
                hintText: 'Nom',
                border: InputBorder.none,
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: (value) => FieldValidator.validateRequired(value),
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
              decoration: const InputDecoration(
                hintText: 'Prénom',
                border: InputBorder.none,
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: (value) => FieldValidator.validateRequired(value),
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
              decoration: const InputDecoration(
                hintText: 'Email',
                border: InputBorder.none,
                prefixIcon: Icon(Icons.alternate_email),
              ),
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
                color: MyColors.success,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Center(
                child: Text(
                  'Modifier les informations',
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
