import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../bloc/auth_bloc/auth_bloc.dart';
import '../../bloc/subscribe_bloc/subscribe_bloc.dart';
import '../../bloc/subscribe_bloc/subscribe_event.dart';
import '../../bloc/subscribe_bloc/subscribe_state.dart';
import '../../constants/string_constants.dart';
import '../../num_extensions.dart';
import '../../utils/field_validator.dart';
import '../../utils/messenger.dart';
import 'form_components/password_text_field.dart';

class SubscribeForm extends HookWidget {
  const SubscribeForm({
    super.key,
    required this.tabController,
  });

  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    final TextEditingController firstNameController =
        useTextEditingController();
    final TextEditingController lastNameController = useTextEditingController();
    final TextEditingController userNameController = useTextEditingController();
    final TextEditingController emailController = useTextEditingController();
    final TextEditingController passwordController = useTextEditingController();
    final TextEditingController confirmPasswordController =
        useTextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return BlocProvider(
      create: (context) => SubscribeBloc(
        context.read<AuthBloc>(),
      ),
      child: BlocBuilder<SubscribeBloc, SubscribeState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  _buildFirstNameLastNameTextFields(
                    context,
                    firstNameController,
                    lastNameController,
                  ),
                  12.ph,
                  TextFormField(
                    readOnly: context.read<SubscribeBloc>().state.loading,
                    decoration: InputDecoration(
                      hintText: StringConstants().username,
                    ),
                    validator: (value) =>
                        FieldValidator.validateRequired(value: value),
                    controller: userNameController,
                  ),
                  12.ph,
                  TextFormField(
                    readOnly: context.read<SubscribeBloc>().state.loading,
                    decoration: InputDecoration(
                      hintText: StringConstants().email,
                    ),
                    validator: (value) => FieldValidator.validateEmail(value!),
                    controller: emailController,
                  ),
                  12.ph,
                  PasswordTextField(
                    passwordController: passwordController,
                  ),
                  12.ph,
                  PasswordTextField(
                    passwordController: confirmPasswordController,
                    previousPasswordController: passwordController,
                  ),
                  22.ph,
                  if (context.read<SubscribeBloc>().state.loading)
                    SizedBox(
                      height: 50,
                      child: Column(
                        children: [
                          10.ph,
                          const SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(),
                          ),
                          10.ph,
                        ],
                      ),
                    ),
                  if (!context.read<SubscribeBloc>().state.loading) 50.ph,
                  _buildSubscribeButton(
                    context: context,
                    formKey: formKey,
                    emailController: emailController,
                    passwordController: passwordController,
                    firstNameController: firstNameController,
                    lastNameController: lastNameController,
                    userNameController: userNameController,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Row _buildFirstNameLastNameTextFields(
    BuildContext context,
    TextEditingController firstNameController,
    TextEditingController lastNameController,
  ) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: TextFormField(
            readOnly: context.read<SubscribeBloc>().state.loading,
            decoration: InputDecoration(
              hintText: StringConstants().firstName,
            ),
            validator: (value) => FieldValidator.validateRequired(
                value: value, minLenghtValue: 3),
            controller: firstNameController,
          ),
        ),
        15.pw,
        Expanded(
          flex: 3,
          child: TextFormField(
            readOnly: context.read<SubscribeBloc>().state.loading,
            decoration: InputDecoration(
              hintText: StringConstants().lastName,
            ),
            validator: (value) => FieldValidator.validateRequired(
                value: value, minLenghtValue: 3),
            controller: lastNameController,
          ),
        ),
      ],
    );
  }

  SizedBox _buildSubscribeButton({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required TextEditingController firstNameController,
    required TextEditingController lastNameController,
    required TextEditingController userNameController,
  }) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35),
          ),
        ),
        onPressed: context.read<SubscribeBloc>().state.loading
            ? null
            : () {
                if (formKey.currentState!.validate()) {
                  context.read<SubscribeBloc>().add(
                        SubscribeRequested(
                          firstName: firstNameController.text,
                          lastName: lastNameController.text,
                          username: userNameController.text,
                          email: emailController.text,
                          password: passwordController.text,
                        ),
                      );
                }
              },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocListener<SubscribeBloc, SubscribeState>(
              listener: (context, state) {
                if (state.error != null) {
                  Messenger.showSnackBarError(state.error!.getDescription());
                }
                if (state.subscribed) {
                  Messenger.showSnackBarSuccess(
                      StringConstants().successfullSubscription);
                }
              },
              child: const SizedBox.shrink(),
            ),
            Center(
              child: Text(
                StringConstants().subscribe,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
