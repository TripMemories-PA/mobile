import 'package:freezed_annotation/freezed_annotation.dart';

import '../avatar/avatar.dart';
import '../message/message.dart';
import '../profile/profile.dart';

part 'conversation.freezed.dart';
part 'conversation.g.dart';

@Freezed()
class Conversation with _$Conversation {
  @JsonSerializable(explicitToJson: true)
  const factory Conversation({
    required int id,
    required List<Profile> users,
    required List<Message> messages,
  }) = _Conversation;

  factory Conversation.fromJson(Map<String, dynamic> json) =>
      _$ConversationFromJson(json);
}
