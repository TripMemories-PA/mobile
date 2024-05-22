import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../auth/model/response/friend_request_response/friend_request_response.dart';
import '../../../meta_object/meta.dart';

part 'friend_request_response.freezed.dart';
part 'friend_request_response.g.dart';

@freezed
class GetFriendRequestResponse with _$GetFriendRequestResponse {
  const factory GetFriendRequestResponse({
    required Meta meta,
    required List<FriendRequest> data,
  }) = _GetFriendsPaginationResponse;

  factory GetFriendRequestResponse.fromJson(Map<String, dynamic> json) =>
      _$GetFriendRequestResponseFromJson(json);
}
