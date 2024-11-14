import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../constants/string_constants.dart';
import '../../num_extensions.dart';
import '../../utils/field_validator.dart';

class EditMeetForm extends HookWidget {
  const EditMeetForm({
    super.key,
    required this.onValidate,
    required this.title,
    required this.description,
  });

  final void Function({required String title, required String description})
      onValidate;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final titleController = useTextEditingController(text: title);
    final descriptionController = useTextEditingController(text: description);
    final formKey = GlobalKey<FormState>();
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.done,
              controller: titleController,
              decoration: const InputDecoration(labelText: StringConstants.title),
              validator: (value) =>
                  FieldValidator.validateRequired(value: value),
            ),
            10.ph,
            TextFormField(
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.done,
              controller: descriptionController,
              decoration:
                  const InputDecoration(labelText: StringConstants.description),
              validator: (value) =>
                  FieldValidator.validateRequired(value: value),
            ),
            50.ph,
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  onValidate(
                    title: titleController.text,
                    description: descriptionController.text,
                  );
                }
              },
              child: const Text(
                StringConstants.validate,
              ),
            ),
            20.ph,
          ],
        ),
      ),
    );
  }
}
