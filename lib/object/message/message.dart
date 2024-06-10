import 'package:freezed_annotation/freezed_annotation.dart';

import '../avatar/avatar.dart';
import '../profile/profile.dart';

part 'message.freezed.dart';
part 'message.g.dart';

@Freezed()
class Message with _$Message {
  @JsonSerializable(explicitToJson: true)
  const factory Message({
    required int id,
    required Profile sender,
    required Profile receiver,
    required String message,
    required DateTime sentAt,
    UploadFile? avatar,
    UploadFile? banner,
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
}
