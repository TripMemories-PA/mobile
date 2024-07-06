import 'profile.dart';

class FriendRequest {
  FriendRequest({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.createdAt,
    required this.updatedAt,
    required this.sender,
  });

  factory FriendRequest.fromJson(Map<String, dynamic> json) {
    return FriendRequest(
      id: json['id'] as int,
      senderId: json['senderId'] as int,
      receiverId: json['receiverId'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      sender: Profile.fromJson(json['sender'] as Map<String, dynamic>),
    );
  }

  int id;
  int senderId;
  int receiverId;
  DateTime createdAt;
  DateTime updatedAt;
  Profile sender;
}
