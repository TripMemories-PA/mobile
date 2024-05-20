import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

import '../../app.config.dart';
import '../../object/avatar/avatar.dart';
import '../../object/profile/profile.dart';
import '../dio.dart';
import '../error/api_error.dart';
import '../error/specific_error/auth_error.dart';
import '../exception/bad_request_exception.dart';
import '../exception/parsing_response_exception.dart';
import 'i_profile_service.dart';
import 'response/friend_request/friend_request_response.dart';
import 'response/friends/get_friends_pagination_response.dart';

class ProfileService implements IProfileService {
  static const String apiMeUrl = '${AppConfig.apiUrl}/me';
  static const String apiMyAvatarUrl = '$apiMeUrl/avatar';
  static const String apiMyBannerUrl = '$apiMeUrl/banner';
  static const String apiMyFriendsUrl = '$apiMeUrl/friends/?page=[nb_page]&perPage=[per_page]';
  static const String apiMyFriendRequestsUrl = '$apiMeUrl/friend-requests/?page=[nb_page]&perPage=[per_page]';
  static const String apiUserUrl = '${AppConfig.apiUrl}/users';

  @override
  Future<Profile> getProfile({required String id}) async {
    Response response;
    try {
      response = await DioClient.instance.get(
        '$apiUserUrl/$id',
      );
    } on BadRequestException {
      throw BadRequestException(AuthError.notAuthenticated());
    }
    try {
      return Profile.fromJson(response.data);
    } catch (e) {
      throw ParsingResponseException(
        ApiError.errorOccurredWhileParsingResponse(),
      );
    }
  }

  @override
  Future<Profile> whoAmI() async {
    Response response;
    try {
      response = await DioClient.instance.get(
        apiMeUrl,
      );
    } on BadRequestException {
      throw BadRequestException(AuthError.notAuthenticated());
    }
    try {
      return Profile.fromJson(response.data);
    } catch (e) {
      throw ParsingResponseException(
        ApiError.errorOccurredWhileParsingResponse(),
      );
    }
  }

  @override
  Future<void> updatePassword({required String password}) {
    // TODO(nono): implement updateProfile
    throw UnimplementedError();
  }

  @override
  Future<void> updateProfile({
    String? username,
    String? lastName,
    String? firstName,
    String? email,
  }) async {
    await DioClient.instance.put(
      apiMeUrl,
      data: {
        'username': username,
        'lastname': lastName,
        'firstname': firstName,
        'email': email,
      },
    );
  }

  @override
  Future<GetFriendsPaginationResponse> getMyFriends({
    required int page,
    required int perPage,
  }) async {
    Response response;
    final String url = apiMyFriendsUrl
        .replaceAll('[nb_page]', page.toString())
        .replaceAll('[per_page]', perPage.toString());
    try {
      response = await DioClient.instance.get(
        url,
      );
    } on BadRequestException {
      throw BadRequestException(AuthError.notAuthenticated());
    }
    try {
      return GetFriendsPaginationResponse.fromJson(response.data);
    } catch (e) {
      throw ParsingResponseException(
        ApiError.errorOccurredWhileParsingResponse(),
      );
    }
  }

  @override
  Future<GetFriendRequestResponse> getMyFriendRequests({
    required int page,
    required int perPage,
  }) async {
    Response response;
    final String url = apiMyFriendRequestsUrl
        .replaceAll('[nb_page]', page.toString())
        .replaceAll('[per_page]', perPage.toString());
    try {
      response = await DioClient.instance.get(
        url,
      );
    } on BadRequestException {
      throw BadRequestException(AuthError.notAuthenticated());
    }
    try {
      return GetFriendRequestResponse.fromJson(response.data);
    } catch (e) {
      throw ParsingResponseException(
        ApiError.errorOccurredWhileParsingResponse(),
      );
    }
  }

  @override
  Future<UploadFile> updateProfilePicture({
    required XFile image,
  }) async {
    Response response;
    try {
      response = await DioClient.instance.post(
        apiMyAvatarUrl,
        data: FormData.fromMap({
          'file': await MultipartFile.fromFile(image.path),
        }),
      );
    } on BadRequestException {
      throw BadRequestException(AuthError.notAuthenticated());
    }
    try {
      return UploadFile.fromJson(response.data);
    } catch (e) {
      throw ParsingResponseException(
        ApiError.errorOccurredWhileParsingResponse(),
      );
    }
  }

  @override
  Future<UploadFile> updateProfileBanner({
    required XFile image,
  }) async {
    Response response;
    try {
      response = await DioClient.instance.post(
        apiMyBannerUrl,
        data: FormData.fromMap({
          'file': await MultipartFile.fromFile(image.path),
        }),
      );
    } on BadRequestException {
      throw BadRequestException(AuthError.notAuthenticated());
    }
    try {
      return UploadFile.fromJson(response.data);
    } catch (e) {
      throw ParsingResponseException(
        ApiError.errorOccurredWhileParsingResponse(),
      );
    }
  }
}
