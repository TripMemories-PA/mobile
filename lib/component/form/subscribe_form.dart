import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../bloc/auth_bloc/auth_bloc.dart';
import '../../bloc/login_bloc/login_bloc.dart';
import '../../bloc/login_bloc/login_event.dart';
import '../../bloc/login_bloc/login_state.dart';
import '../../constants/my_colors.dart';
import '../../num_extensions.dart';
import '../../utils/field_validator.dart';

class SubscribeForm extends HookWidget {
  const SubscribeForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController firstNameController =
        useTextEditingController();
    final TextEditingController lastNameController =
        useTextEditingController();
    final TextEditingController userNameController =
        useTextEditingController();
    final TextEditingController emailController =
        useTextEditingController(text: 'test@mail.com');
    final TextEditingController passwordController =
        useTextEditingController(text: 'Test1234!');
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final hidePassword = useState(true);
    final hideConfirmPassword = useState(true);
    return BlocProvider(
      create: (context) => LoginBloc(
        context.read<AuthBloc>(),
      ),
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          readOnly: context.read<LoginBloc>().state.loading,
                          decoration: const InputDecoration(
                            hintText: 'Prénom',
                          ),
                          validator: (value) => FieldValidator.validateRequired(value),
                          controller: firstNameController,
                        ),
                      ),
                      15.pw,
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          readOnly: context.read<LoginBloc>().state.loading,
                          decoration: const InputDecoration(
                            hintText: 'Nom',
                          ),
                          validator: (value) => FieldValidator.validateRequired(value),
                          controller: lastNameController,
                        ),
                      ),
                    ],
                  ),
                  12.ph,
                  TextFormField(
                    readOnly: context.read<LoginBloc>().state.loading,
                    decoration: const InputDecoration(
                      hintText: "Nom d'utilisateur",
                    ),
                    validator: (value) => FieldValidator.validateRequired(value),
                    controller: userNameController,
                  ),
                  12.ph,
                  TextFormField(
                    readOnly: context.read<LoginBloc>().state.loading,
                    decoration: const InputDecoration(
                      hintText: 'Adresse e-mail',
                    ),
                    validator: (value) => FieldValidator.validateEmail(value!),
                    controller: emailController,
                  ),
                  12.ph,
                  TextFormField(
                    readOnly: context.read<LoginBloc>().state.loading,
                    obscureText: hidePassword.value,
                    decoration: InputDecoration(
                      errorMaxLines: 4,
                      hintText: 'Mot de passe',
                      suffixIcon: InkWell(
                        child: Icon(
                          hidePassword.value
                              ? Icons.remove_red_eye
                              : Icons.visibility_off,
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
                    validator: (value) =>
                        FieldValidator.validatePassword(value),
                    controller: passwordController,
                  ),
                  12.ph,
                  TextFormField(
                    readOnly: context.read<LoginBloc>().state.loading,
                    obscureText: hidePassword.value,
                    decoration: InputDecoration(
                      errorMaxLines: 4,
                      hintText: 'Confirmer le mot de passe',
                      suffixIcon: InkWell(
                        child: Icon(
                          hideConfirmPassword.value
                              ? Icons.remove_red_eye
                              : Icons.visibility_off,
                          size: 20,
                          color: MyColors.darkGrey,
                        ),
                        onTap: () {
                          hideConfirmPassword.value = !hideConfirmPassword.value;
                        },
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 8.0,
                      ),
                    ),
                    validator: (value) =>
                        FieldValidator.validatePassword(value),
                    controller: passwordController,
                  ),
                  22.ph,
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35),
                        ),
                      ),
                      onPressed: context.read<LoginBloc>().state.loading ? null : () {
                        if (formKey.currentState!.validate()) {
                          context.read<LoginBloc>().add(
                            LoginRequested(
                              email: emailController.text,
                              password: passwordController.text,
                            ),
                          );
                        }
                      },
                      child: const Center(
                        child: Text(
                          "S'inscrire",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  if (context.read<LoginBloc>().state.loading)
                    SizedBox(
                      height: 50,
                      child: Column(
                        children: [
                          10.ph,
                          const SizedBox(
                            height: 30,
                              width: 30,
                              child: CircularProgressIndicator(),),
                          10.ph,
                        ],
                      ),
                    ),
                  if (!context.read<LoginBloc>().state.loading) 50.ph,
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
