import '../../../../object/uploaded_file.dart';
import '../../../../object/user_type.dart';

class Profile {
  Profile({
    required this.id,
    required this.email,
    required this.username,
    this.firstname,
    this.lastname,
    this.userTypeId,
    this.poiId,
    this.avatar,
    this.banner,
    required this.userType,
    this.isFriend,
    this.hasSentFriendRequest,
    this.hasReceivedFriendRequest,
    this.poisCount,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      userTypeId: json['userTypeId'],
      poiId: json['poiId'],
      avatar:
          json['avatar'] != null ? UploadFile.fromJson(json['avatar']) : null,
      banner:
          json['banner'] != null ? UploadFile.fromJson(json['banner']) : null,
      userType: UserType.fromJson(json['userType']),
      isFriend: json['isFriend'],
      hasSentFriendRequest: json['hasSentFriendRequest'],
      hasReceivedFriendRequest: json['hasReceivedFriendRequest'],
      poisCount: json['poisCount'],
    );
  }

  Profile copyWith({
    int? id,
    String? email,
    String? username,
    String? firstname,
    String? lastname,
    int? userTypeId,
    int? poiId,
    UploadFile? avatar,
    UploadFile? banner,
    UserType? userType,
    bool? isFriend,
    bool? hasSentFriendRequest,
    bool? hasReceivedFriendRequest,
    int? poisCount,
  }) {
    return Profile(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      userTypeId: userTypeId ?? this.userTypeId,
      poiId: poiId ?? this.poiId,
      avatar: avatar ?? this.avatar,
      banner: banner ?? this.banner,
      userType: userType ?? this.userType,
      isFriend: isFriend ?? this.isFriend,
      hasSentFriendRequest: hasSentFriendRequest ?? this.hasSentFriendRequest,
      hasReceivedFriendRequest:
          hasReceivedFriendRequest ?? this.hasReceivedFriendRequest,
      poisCount: poisCount ?? this.poisCount,
    );
  }

  final int id;
  final String email;
  final String username;
  final String? firstname;
  final String? lastname;
  final int? userTypeId;
  final int? poiId;
  final UploadFile? avatar;
  final UploadFile? banner;
  final UserType userType;
  final bool? isFriend;
  final bool? hasSentFriendRequest;
  final bool? hasReceivedFriendRequest;
  final int? poisCount;
}