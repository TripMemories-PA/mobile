import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_post_query.freezed.dart';
part 'create_post_query.g.dart';

@Freezed()
class CreatePostQuery with _$CreatePostQuery {
  @JsonSerializable(explicitToJson: true)
  const factory CreatePostQuery({
    required String content,
    required int imageId,
    required int poiId,
    required String note,
  }) = _CreatePostQuery;

  factory CreatePostQuery.fromJson(Map<String, dynamic> json) =>
      _$CreatePostQueryFromJson(json);
}
