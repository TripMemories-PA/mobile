import 'message.dart';
import 'profile.dart';

class Conversation {
  Conversation({
    required this.id,
    required this.users,
    required this.messages,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'] as int,
      users: (json['users'] as List)
          .map((e) => Profile.fromJson(e as Map<String, dynamic>))
          .toList(),
      messages: (json['messages'] as List)
          .map((e) => Message.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  final int id;
  final List<Profile> users;
  final List<Message> messages;
}
