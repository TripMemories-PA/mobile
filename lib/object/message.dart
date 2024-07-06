import 'profile.dart';
import 'uploaded_file.dart';

class Message {
  Message({
    required this.id,
    required this.sender,
    required this.receiver,
    required this.message,
    required this.sentAt,
    this.avatar,
    this.banner,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as int,
      sender: Profile.fromJson(json['sender'] as Map<String, dynamic>),
      receiver: Profile.fromJson(json['receiver'] as Map<String, dynamic>),
      message: json['message'] as String,
      sentAt: DateTime.parse(json['sentAt'] as String),
      avatar: json['avatar'] == null
          ? null
          : UploadFile.fromJson(json['avatar'] as Map<String, dynamic>),
      banner: json['banner'] == null
          ? null
          : UploadFile.fromJson(json['banner'] as Map<String, dynamic>),
    );
  }

  int id;
  Profile sender;
  Profile receiver;
  String message;
  DateTime sentAt;
  UploadFile? avatar;
  UploadFile? banner;
}
