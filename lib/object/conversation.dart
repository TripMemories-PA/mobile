import 'message.dart';
import 'meta_object.dart';

class Conversation {
  Conversation({
    required this.meta,
    required this.messages,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      meta: MetaObject.fromJson(json['meta'] as Map<String, dynamic>),
      messages: (json['data'] as List)
          .map((e) => Message.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Conversation copyWith({
    MetaObject? meta,
    List<Message>? messages,
  }) {
    return Conversation(
      meta: meta ?? this.meta,
      messages: messages ?? this.messages,
    );
  }

  final MetaObject meta;
  final List<Message> messages;
}
