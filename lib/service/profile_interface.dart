import '../api/profile/response/friends/get_friends_pagination_response.dart';
import '../object/profile/profile.dart';

abstract class ProfileDataSourceInterface {
  Future<Profile> getProfile(String id);

  Future<GetFriendsPaginationResponse> getFriends(
      {required String id, required int page, required int perPage});
}
