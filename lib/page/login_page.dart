import 'package:flutter/material.dart';

import '../component/form/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: LoginForm(),
        ),
      ),
    );
  }
}
