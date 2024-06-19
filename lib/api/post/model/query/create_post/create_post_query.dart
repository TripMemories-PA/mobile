import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_post_query.freezed.dart';
part 'create_post_query.g.dart';

@Freezed()
class CreatePostQuery with _$CreatePostQuery {
  @JsonSerializable(explicitToJson: true)
  const factory CreatePostQuery({
    required String title,
    required String content,
    int? imageId,
    required int poiId,
    required double note,
  }) = _CreatePostQuery;

  factory CreatePostQuery.fromJson(Map<String, dynamic> json) =>
      _$CreatePostQueryFromJson(json);
}
