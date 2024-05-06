import '../api/profile/response/friends/get_friends_pagination_response.dart';
import '../object/profile/profile.dart';
import '../service/profile_remote_data_source.dart';

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
}
