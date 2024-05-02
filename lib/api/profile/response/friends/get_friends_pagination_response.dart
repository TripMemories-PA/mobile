import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../object/profile/profile.dart';

part 'get_friends_pagination_response.freezed.dart';
part 'get_friends_pagination_response.g.dart';

@freezed
class GetFriendsPaginationResponse with _$GetFriendsPaginationResponse {
  const factory GetFriendsPaginationResponse({
    required Meta meta,
    required List<Profile> data,
  }) = _GetFriendsPaginationResponse;

  factory GetFriendsPaginationResponse.fromJson(Map<String, dynamic> json) =>
      _$GetFriendsPaginationResponseFromJson(json);
}

@freezed
class Meta with _$Meta {
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
