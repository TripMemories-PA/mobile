import 'package:freezed_annotation/freezed_annotation.dart';

part 'who_am_i_response.freezed.dart';
part 'who_am_i_response.g.dart';

@Freezed()
class WhoAmIResponse with _$WhoAmIResponse {
  const factory WhoAmIResponse({
    required int id,
    required String name,
  }) = _WhoAmIResponse;

  factory WhoAmIResponse.fromJson(Map<String, dynamic> json) =>
      _$WhoAmIResponseFromJson(json);
}
