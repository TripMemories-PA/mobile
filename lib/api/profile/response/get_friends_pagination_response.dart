import '../../../object/meta_object.dart';
import '../../../object/profile.dart';

class GetFriendsPaginationResponse {
  const GetFriendsPaginationResponse({
    required this.meta,
    required this.data,
  });

  factory GetFriendsPaginationResponse.fromJson(Map<String, dynamic> json) {
    return GetFriendsPaginationResponse(
      meta: MetaObject.fromJson(json['meta']),
      data: List<Profile>.from(
        json['data'].map((x) => Profile.fromJson(x)),
      ),
    );
  }

  GetFriendsPaginationResponse copyWith({
    MetaObject? meta,
    List<Profile>? data,
  }) {
    return GetFriendsPaginationResponse(
      meta: meta ?? this.meta,
      data: data ?? this.data,
    );
  }

  final MetaObject meta;
  final List<Profile> data;
}
