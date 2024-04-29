import 'package:flutter/cupertino.dart';

import 'auth_state.dart';

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class AppStarted extends AuthEvent {}

class ChangeAuthState extends AuthEvent {
  const ChangeAuthState(
    this.newState,
  );

  final AuthState newState;
}
