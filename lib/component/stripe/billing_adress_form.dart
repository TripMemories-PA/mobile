import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import '../../constants/string_constants.dart';
import '../../num_extensions.dart';
import '../../page/payment_sheet_screen.dart';
import '../../utils/field_validator.dart';

class BillingDetailsForm extends StatelessWidget {
  const BillingDetailsForm({
    super.key,
    required this.onSubmit,
    required this.controllers,
  });

  final Function(BillingDetails) onSubmit;
  final BillingDetailsControllers controllers;

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    void submitForm() {
      if (formKey.currentState!.validate()) {
        final billingDetails = BillingDetails(
          name: controllers.nameController.text,
          address: Address(
            city: controllers.cityController.text,
            country: controllers.countryController.text,
            line1: controllers.line1Controller.text,
            line2: controllers.line2Controller.text,
            state: controllers.stateController.text,
            postalCode: controllers.postalCodeController.text,
          ),
        );

        onSubmit(billingDetails);
      }
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.done,
                  controller: controllers.nameController,
                  decoration:
                      const InputDecoration(labelText: StringConstants.name),
                  validator: (value) =>
                      FieldValidator.validateRequired(value: value),
                ),
                10.ph,
                TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.done,
                  controller: controllers.emailController,
                  decoration:
                      const InputDecoration(labelText: StringConstants.email),
                  validator: (value) =>
                      FieldValidator.validateRequired(value: value),
                ),
                10.ph,
                TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.done,
                  controller: controllers.phoneController,
                  decoration:
                      const InputDecoration(labelText: StringConstants.phoneNumber),
                  validator: (value) =>
                      FieldValidator.validateRequired(value: value),
                ),
                10.ph,
                TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.done,
                  controller: controllers.cityController,
                  decoration:
                      const InputDecoration(labelText: StringConstants.city),
                  validator: (value) =>
                      FieldValidator.validateRequired(value: value),
                ),
                10.ph,
                TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.done,
                  controller: controllers.postalCodeController,
                  decoration:
                      const InputDecoration(labelText: StringConstants.zipCode),
                  validator: (value) =>
                      FieldValidator.validateRequired(value: value),
                ),
                10.ph,
                TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.done,
                  controller: controllers.countryController,
                  decoration:
                      const InputDecoration(labelText: StringConstants.country),
                  validator: (value) =>
                      FieldValidator.validateRequired(value: value),
                ),
                10.ph,
                TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.done,
                  controller: controllers.line1Controller,
                  decoration:
                      const InputDecoration(labelText: StringConstants.address),
                  validator: (value) =>
                      FieldValidator.validateRequired(value: value),
                ),
                20.ph,
                ElevatedButton(
                  onPressed: submitForm,
                  child: const Text(StringConstants.validate),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
