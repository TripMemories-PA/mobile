import 'package:flutter/cupertino.dart';

@immutable
abstract class LoginEvent {
  const LoginEvent();
}

class LoginRequested extends LoginEvent {
  const LoginRequested({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;
}

class LogoutRequested extends LoginEvent {}
