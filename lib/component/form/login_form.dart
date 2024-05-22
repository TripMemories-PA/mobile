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
    final TextEditingController emailController =
        useTextEditingController(text: 'test@mail.com');
    final TextEditingController passwordController =
        useTextEditingController(text: 'Test1234!');
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final rememberMe = useState(false);
    final hidePassword = useState(true);
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
                  TextFormField(
                    readOnly: context.read<LoginBloc>().state.loading,
                    decoration: const InputDecoration(
                      hintText: 'Adresse e-mail',
                    ),
                    validator: (value) => FieldValidator.validateEmail(value!),
                    controller: emailController,
                  ),
                  15.ph,
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
                  15.ph,
                  Row(
                    children: [
                      Checkbox(
                        value: rememberMe.value,
                        onChanged: context.read<LoginBloc>().state.loading ? null : (bool? value) {
                          rememberMe.value = value!;
                        },
                        checkColor: Colors.black,
                      ),
                      Text(
                        'Se souvenir de moi',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const Spacer(),
                      // TODO(nono): Add the forgot password feature
                      InkWell(
                        child: Text(
                          'Mot de passe oublié ?',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                decoration: TextDecoration.underline,
                              ),
                        ),
                        onTap: () {},
                      ),
                    ],
                  ),
                  if (context.read<LoginBloc>().state.loading)
                    SizedBox(
                      height: 80,
                      child: Column(
                        children: [
                          20.ph,
                          const CircularProgressIndicator(),
                          20.ph,
                        ],
                      ),
                    ),
                  if (!context.read<LoginBloc>().state.loading) 80.ph,
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
                          'Se connecter',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
