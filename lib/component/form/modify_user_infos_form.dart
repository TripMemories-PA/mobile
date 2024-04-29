import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../constants/my_colors.dart';
import '../../num_extensions.dart';
import '../../utils/field_validator.dart';

class ModifyUserInfosForm extends HookWidget {
  const ModifyUserInfosForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController userNameController = useTextEditingController();
    final TextEditingController nameController = useTextEditingController();
    final TextEditingController firstNameController =
        useTextEditingController();
    final TextEditingController emailController = useTextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
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
              controller: userNameController,
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
              controller: nameController,
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
          InkWell(
            onTap: () async {
              if (formKey.currentState!.validate()) {
                // TODO(nono): Implement the update user infos logic
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
