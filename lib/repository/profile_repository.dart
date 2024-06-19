import '../api/post/model/response/get_all_posts_response.dart';
import '../api/profile/response/friend_request/friend_request_response.dart';
import '../api/profile/response/friends/get_friends_pagination_response.dart';
import '../object/profile/profile.dart';
import '../service/profile/profile_remote_data_source.dart';

// TODO(nono): implement the profilelocalDataSource
class ProfileRepository {
  ProfileRepository({
    required this.profileRemoteDataSource,
    //required this.profilelocalDataSource,
  });

  final ProfileRemoteDataSource profileRemoteDataSource;

  //final ProfileLocalDataSource profilelocalDataSource;

  Future<Profile> getProfile(String id) async {
    return profileRemoteDataSource.getProfile(id);
  }

  Future<Profile> whoAmI() async {
    return profileRemoteDataSource.whoAmI();
  }

  /*Future<Profile> getLocalProfile(String id) async {
    return profilelocalDataSource.getProfile(id);
  }*/

  Future<void> updateProfile(Profile profile) async {}

  Future<void> updatePassword(String password) async {}

  Future<GetFriendsPaginationResponse> getMyFriends({
    required int page,
    required int perPage,
  }) async {
    return profileRemoteDataSource.getMyFriends(page: page, perPage: perPage);
  }

  Future<GetFriendRequestResponse> getMyFriendRequests({
    required int page,
    required int perPage,
  }) async {
    return profileRemoteDataSource.getMyFriendRequests(
      page: page,
      perPage: perPage,
    );
  }

  Future<GetFriendsPaginationResponse> getUsers({
    required int page,
    required int perPage,
    String? searchName,
  }) async {
    return profileRemoteDataSource.getUsers(
      page: page,
      perPage: perPage,
      searchName: searchName,
    );
  }

  Future<GetAllPostsResponse> getMyPosts({
    required int page,
    required int perPage,
  }) async {
    return profileRemoteDataSource.getMyPosts(
      page: page,
      perPage: perPage,
    );
  }
}
