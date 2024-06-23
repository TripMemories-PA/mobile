import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../object/profile/profile.dart';

part 'friend_request.freezed.dart';
part 'friend_request.g.dart';

@freezed
class FriendRequest with _$FriendRequest {
  const factory FriendRequest({
    required int id,
    required int senderId,
    required int receiverId,
    required DateTime createdAt,
    required DateTime updatedAt,
    required Profile sender,
  }) = _FriendRequest;

  factory FriendRequest.fromJson(Map<String, dynamic> json) =>
      _$FriendRequestFromJson(json);
}
