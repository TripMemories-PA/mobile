import 'package:flutter/cupertino.dart';

@immutable
abstract class SubscribeEvent {
  const SubscribeEvent();
}

class SubscribeRequested extends SubscribeEvent {
  const SubscribeRequested({
    required this.email,
    required this.password,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.stayLoggedIn,
  });

  final String email;
  final String password;
  final String username;
  final String firstName;
  final String lastName;
  final bool stayLoggedIn;
}

class LogoutRequested extends SubscribeEvent {}
