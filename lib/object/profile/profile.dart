import 'package:freezed_annotation/freezed_annotation.dart';

import '../avatar/avatar.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

@Freezed()
class Profile with _$Profile {
  @JsonSerializable(explicitToJson: true)
  const factory Profile({
    required int id,
    required String username,
    required String email,
    required String firstname,
    required String lastname,
    required UploadFile avatar,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);
}
