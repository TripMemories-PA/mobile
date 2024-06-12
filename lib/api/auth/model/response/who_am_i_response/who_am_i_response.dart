import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../object/avatar/uploaded_file.dart';
import '../friend_request_response/friend_request_response.dart';

part 'who_am_i_response.freezed.dart';
part 'who_am_i_response.g.dart';

@freezed
class WhoAmIResponse with _$WhoAmIResponse {
  const factory WhoAmIResponse({
    required int id,
    required String email,
    required String username,
    String? firstname,
    String? lastname,
    UploadFile? avatar,
    UploadFile? banner,
    List<FriendRequest>? sentFriendRequests,
    List<FriendRequest>? receivedFriendRequests,
    List<dynamic>? friends,
  }) = _WhoAmIResponse;

  factory WhoAmIResponse.fromJson(Map<String, dynamic> json) =>
      _$WhoAmIResponseFromJson(json);
}
