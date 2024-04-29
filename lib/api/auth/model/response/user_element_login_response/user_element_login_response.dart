import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_element_login_response.freezed.dart';
part 'user_element_login_response.g.dart';

@Freezed()
class UserElementLogInResponse with _$UserElementLogInResponse {
  const factory UserElementLogInResponse({
    required int id,
    required String name,
  }) = _UserElementLogInResponse;

  factory UserElementLogInResponse.fromJson(Map<String, dynamic> json) =>
      _$UserElementLogInResponseFromJson(json);
}
