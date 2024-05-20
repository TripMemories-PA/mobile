import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../object/profile/profile.dart';
import '../../../meta_object/meta.dart';

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
