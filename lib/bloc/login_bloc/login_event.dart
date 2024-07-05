import 'package:flutter/cupertino.dart';

@immutable
abstract class LoginEvent {
  const LoginEvent();
}

class LoginRequested extends LoginEvent {
  const LoginRequested({
    required this.email,
    required this.password,
    required this.stayLoggedIn,
  });

  final String email;
  final String password;
  final bool stayLoggedIn;
}

class LogoutRequested extends LoginEvent {}
