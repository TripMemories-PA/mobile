import 'package:flutter/cupertino.dart';

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class AppStarted extends AuthEvent {}

class ChangeToLoggedInStatus extends AuthEvent {
  const ChangeToLoggedInStatus({
    required this.authToken,
  });

  final String authToken;
}

class ChangeToLoggedOutStatus extends AuthEvent {
  const ChangeToLoggedOutStatus();
}

class DeleteAccountEvent extends AuthEvent {}
