import 'package:flutter/cupertino.dart';

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class AppStarted extends AuthEvent {}

class SplashScreenDisplayed extends AuthEvent {}

class ChangeToLoggedInStatus extends AuthEvent {
  const ChangeToLoggedInStatus({
    required this.authToken,
    required this.stayLoggedIn,
  });

  final String authToken;
  final bool stayLoggedIn;
}

class ChangeToLoggedOutStatus extends AuthEvent {
  const ChangeToLoggedOutStatus();
}

class DeleteAccountEvent extends AuthEvent {}

class SendMyLocation extends AuthEvent {}
