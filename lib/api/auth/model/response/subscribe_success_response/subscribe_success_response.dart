import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscribe_success_response.freezed.dart';

part 'subscribe_success_response.g.dart';

@freezed
class SubscribeSuccessResponse with _$SubscribeSuccessResponse {
  const factory SubscribeSuccessResponse({
    required String username,
    required String email,
    required String firstName,
    required String lastName,
    required String id,

  }) = _SubscribeSuccessResponse;

  factory SubscribeSuccessResponse.fromJson(Map<String, dynamic> json) =>
      _$SubscribeSuccessResponseFromJson(json);
}
