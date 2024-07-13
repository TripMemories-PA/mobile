import '../../../../object/meta_object.dart';
import '../../../../object/profile.dart';

class MeetUsers {
  MeetUsers({
    required this.meta,
    required this.data,
  });

  factory MeetUsers.fromJson(Map<String, dynamic> json) {
    return MeetUsers(
      meta: MetaObject.fromJson(json['meta']),
      data: List<Profile>.from(json['data'].map((x) => Profile.fromJson(x))),
    );
  }

  final MetaObject meta;
  final List<Profile> data;

  MeetUsers copyWith({
    MetaObject? meta,
    List<Profile>? data,
  }) {
    return MeetUsers(
      meta: meta ?? this.meta,
      data: data ?? this.data,
    );
  }
}
