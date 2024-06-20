import '../../api/profile/response/friend_request/friend_request_response.dart';
import '../../api/profile/response/friends/get_friends_pagination_response.dart';
import '../../object/profile/profile.dart';

abstract class IProfileRepository {
  Future<Profile> getProfile(int id);

  Future<Profile> whoAmI();

  Future<GetFriendsPaginationResponse> getMyFriends({
    required int page,
    required int perPage,
  });

  Future<GetFriendRequestResponse> getMyFriendRequests({
    required int page,
    required int perPage,
  });

  Future<GetFriendsPaginationResponse> getUsers({
    required int page,
    required int perPage,
    String? searchName,
  });
}
