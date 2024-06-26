import 'package:freezed_annotation/freezed_annotation.dart';

import '../avatar/uploaded_file.dart';

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
    required bool? hasSentFriendRequest,
    required bool? hasReceivedFriendRequest,
    UploadFile? avatar,
    UploadFile? banner,
    required int? poisCount,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
}
