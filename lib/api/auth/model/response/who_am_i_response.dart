import '../../../../object/avatar/uploaded_file.dart';
import '../../../../object/user_type.dart';

class WhoAmIResponse {

  WhoAmIResponse({
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

  factory WhoAmIResponse.fromJson(Map<String, dynamic> json) {
    return WhoAmIResponse(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      userTypeId: json['userTypeId'],
      poiId: json['poiId'],
      avatar: json['avatar'] != null ? UploadFile.fromJson(json['avatar']) : null,
      banner: json['banner'] != null ? UploadFile.fromJson(json['banner']) : null,
      userType: UserType.fromJson(json['userType']),
      isFriend: json['isFriend'],
      hasSentFriendRequest: json['hasSentFriendRequest'],
      hasReceivedFriendRequest: json['hasReceivedFriendRequest'],
      poisCount: json['poisCount'],
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
