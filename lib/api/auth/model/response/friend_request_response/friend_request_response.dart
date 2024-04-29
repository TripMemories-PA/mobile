
import 'package:freezed_annotation/freezed_annotation.dart';

part 'friend_request_response.freezed.dart';
part 'friend_request_response.g.dart';

@freezed
class FriendRequest with _$FriendRequest {
  const factory FriendRequest({
    required int id,
    @JsonKey(name: 'senderId') required int senderId,
    @JsonKey(name: 'receiverId') required int receiverId,
    @JsonKey(name: 'createdAt') required String createdAt,
    @JsonKey(name: 'updatedAt') required String updatedAt,
  }) = _FriendRequest;

  factory FriendRequest.fromJson(Map<String, dynamic> json) =>
      _$FriendRequestFromJson(json);
}
