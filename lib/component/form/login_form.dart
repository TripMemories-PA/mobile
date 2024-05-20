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

class LoginForm extends HookWidget {
  const LoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = useTextEditingController(text: 'test@mail.com');
    final TextEditingController passwordController = useTextEditingController(text: 'Test1234!');
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return BlocProvider(
      create: (context) => LoginBloc(
        context.read<AuthBloc>(),
      ),
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
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
                      hintText: 'Email',
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.alternate_email),
                    ),
                    validator: (value) => FieldValidator.validateEmail(value!),
                    controller: emailController,
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
                      hintText: 'Mot de passe',
                      border: InputBorder.none,
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: InkWell(
                        child: const Icon(Icons.remove_red_eye_outlined),
                        onTap: () {},
                      ),
                    ),
                    validator: (value) =>
                        FieldValidator.validatePassword(value),
                    controller: passwordController,
                  ),
                ),
                15.ph,
                InkWell(
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      context.read<LoginBloc>().add(
                            LoginRequested(
                              email: emailController.text,
                              password: passwordController.text,
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
                        'Se connecter',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                if (context.read<LoginBloc>().state.loading)
                  const CircularProgressIndicator(),
              ],
            ),
          );
        },
      ),
    );
  }
}
