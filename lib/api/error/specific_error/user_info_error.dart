import '../../../constants/string_constants.dart';
import '../api_error.dart';

class UserInfoError extends ApiError {
  const UserInfoError(super.description);

  static UserInfoError cannotGetUserDetails() {
    return const UserInfoError(StringConstants.cannotGetUserDetails);
  }

  static UserInfoError cannotGetUserTweets() {
    return const UserInfoError(StringConstants.cannotGetUserPosts);
  }
}
