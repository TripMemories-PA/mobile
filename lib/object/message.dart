import 'profile.dart';

class Message {
  Message({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.sender,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    try {
      return Message(
        id: json['id'] as int,
        content: json['content'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        sender: Profile.fromJson(json['sender'] as Map<String, dynamic>),
      );
    } catch (e) {
      throw Exception('Failed to create message from json: $e');
    }
  }

  int id;
  String content;
  DateTime createdAt;
  Profile sender;
}
