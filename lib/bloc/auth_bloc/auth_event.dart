import 'package:flutter/cupertino.dart';

import '../../api/auth/model/response/who_am_i_response/who_am_i_response.dart';

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class AppStarted extends AuthEvent {}

class ChangeToLoggedInStatus extends AuthEvent {
  const ChangeToLoggedInStatus({
    required this.user,
    required this.authToken,
  });

  final WhoAmIResponse user;
  final String authToken;
}

class ChangeToLoggedOutStatus extends AuthEvent {
  const ChangeToLoggedOutStatus();
}
