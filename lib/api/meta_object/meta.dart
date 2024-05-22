import 'package:freezed_annotation/freezed_annotation.dart';

part 'meta.freezed.dart';
part 'meta.g.dart';

@Freezed()
class Meta with _$Meta {
  @JsonSerializable(explicitToJson: true)
  const factory Meta({
    required int total,
    required int perPage,
    required int currentPage,
    required int lastPage,
    required int firstPage,
    required String firstPageUrl,
    required String lastPageUrl,
    required String? nextPageUrl,
    required String? previousPageUrl,
  }) = _Meta;

  factory Meta.fromJson(Map<String, dynamic> json) => _$MetaFromJson(json);
}
