import '../../../../object/meet.dart';
import '../../../../object/meta_object.dart';

class MeetResponse {
  MeetResponse({
    required this.meta,
    required this.data,
  });

  factory MeetResponse.fromJson(Map<String, dynamic> json) {
    return MeetResponse(
      meta: MetaObject.fromJson(json['meta']),
      data: List<Meet>.from(json['data'].map((x) => Meet.fromJson(x))),
    );
  }

  MetaObject meta;
  List<Meet> data;

  MeetResponse copyWith({
    MetaObject? meta,
    List<Meet>? data,
  }) {
    return MeetResponse(
      meta: meta ?? this.meta,
      data: data ?? this.data,
    );
  }
}
