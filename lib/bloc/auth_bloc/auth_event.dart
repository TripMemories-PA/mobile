import 'package:flutter/cupertino.dart';

import '../../api/auth/model/response/who_am_i_response/who_am_i_response.dart';

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class AppStarted extends AuthEvent {}

class ChangeToLoggedInStatus extends AuthEvent {
  const ChangeToLoggedInStatus(
    this.user,
  );

  final WhoAmIResponse user;
}

class ChangeToLoggedOutStatus extends AuthEvent {
  const ChangeToLoggedOutStatus();
}
