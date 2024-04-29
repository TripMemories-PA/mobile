import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_success_response.freezed.dart';

part 'auth_success_response.g.dart';

@freezed
class AuthSuccessResponse with _$AuthSuccessResponse {
  const factory AuthSuccessResponse({
    required String type,
    required String token,
    @JsonKey(name: 'expires_at') required String expiresAt,
  }) = _AuthSuccessResponse;

  factory AuthSuccessResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthSuccessResponseFromJson(json);
}
