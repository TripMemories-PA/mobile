import '../../../object/friend_request.dart';
import '../../../object/meta_object.dart';

class GetFriendRequestResponse {
  GetFriendRequestResponse({
    required this.meta,
    required this.data,
  });

  factory GetFriendRequestResponse.fromJson(Map<String, dynamic> json) {
    return GetFriendRequestResponse(
      meta: MetaObject.fromJson(json['meta']),
      data: List<FriendRequest>.from(
        json['data'].map((x) => FriendRequest.fromJson(x)),
      ),
    );
  }

  GetFriendRequestResponse copyWith({
    MetaObject? meta,
    List<FriendRequest>? data,
  }) {
    return GetFriendRequestResponse(
      meta: meta ?? this.meta,
      data: data ?? this.data,
    );
  }

  MetaObject meta;
  List<FriendRequest> data;
}
