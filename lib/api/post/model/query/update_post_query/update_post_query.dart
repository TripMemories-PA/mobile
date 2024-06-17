import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_post_query.freezed.dart';
part 'update_post_query.g.dart';

@Freezed()
class UpdatePostQuery with _$UpdatePostQuery {
  @JsonSerializable(explicitToJson: true)
  const factory UpdatePostQuery({
    required int postId,
    String? content,
    int? imageId,
    int? poiId,
    String? note,
  }) = _UpdatePostQuery;

  factory UpdatePostQuery.fromJson(Map<String, dynamic> json) =>
      _$UpdatePostQueryFromJson(json);
}
