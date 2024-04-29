import 'package:freezed_annotation/freezed_annotation.dart';

import '../user_element_login_response/user_element_login_response.dart';

part 'auth_success_response.freezed.dart';

part 'auth_success_response.g.dart';

@Freezed()
class AuthSuccessResponse with _$AuthSuccessResponse {
  @JsonSerializable(explicitToJson: true)
  const factory AuthSuccessResponse({
    required String authToken,
    required UserElementLogInResponse user,
  }) = _AuthSuccessResponse;

  factory AuthSuccessResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthSuccessResponseFromJson(json);
}
