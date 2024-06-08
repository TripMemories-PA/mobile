import 'package:freezed_annotation/freezed_annotation.dart';

import '../avatar/avatar.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

@Freezed()
class Profile with _$Profile {
  @JsonSerializable(explicitToJson: true)
  const factory Profile({
    required int id,
    required String email,
    required String username,
    required String? firstname,
    required String? lastname,
    required bool? isFriend,
  required bool? isSentFriendRequest,
  required bool? isReceivedFriendRequest,
    UploadFile? avatar,
    UploadFile? banner,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
}
