import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../api/error/api_error.dart';
import '../../api/error/specific_error/auth_error.dart';
import '../../api/error/specific_error/file_upload_error.dart';
import '../../api/exception/custom_exception.dart';
import '../../api/post/model/response/get_all_posts_response.dart';
import '../../api/profile/i_profile_service.dart';
import '../../api/profile/response/get_friends_pagination_response.dart';
import '../../local_storage/secure_storage/auth_token_handler.dart';
import '../../object/meta_object.dart';
import '../../object/position.dart';
import '../../object/profile.dart';
import '../../object/radius.dart';
import '../../object/uploaded_file.dart';
import '../../repository/profile/profile_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    required ProfileRepository profileRepository,
    required this.profileService,
  }) : super(const ProfileState()) {
    on<GetProfileEvent>(
      (event, emit) async {
        emit(state.copyWith(status: ProfileStatus.loading));
        try {
          if (event.userId != null) {
            final Profile profile =
                await profileRepository.getProfile(event.userId!);
            emit(
              state.copyWith(
                profile: profile,
                status: ProfileStatus.notLoading,
              ),
            );
          } else {
            final String? authToken = await AuthTokenHandler().getAuthToken();
            if (authToken == null) {
              emit(
                state.copyWith(
                  status: ProfileStatus.error,
                  error: AuthError.notAuthenticated(),
                ),
              );
              return;
            }
            final Profile profile = await profileRepository.whoAmI();
            emit(
              state.copyWith(
                profile: profile,
                status: ProfileStatus.notLoading,
              ),
            );
          }
          if (event.userId == null) {
            add(
              GetFriendsEvent(isRefresh: true),
            );
          }
        } catch (e) {
          emit(
            state.copyWith(
              status: ProfileStatus.error,
              error: e is CustomException
                  ? e.apiError
                  : ApiError.cannotReachLocalData(),
            ),
          );
        }
        //}
      },
    );

    on<UpdateProfileEvent>((event, emit) async {
      try {
        emit(state.copyWith(status: ProfileStatus.loading));
        await profileService.updateProfile(
          username: event.username,
          lastName: event.lastName,
          firstName: event.firstName,
          email: event.email,
        );
        add(GetProfileEvent());
        emit(state.copyWith(status: ProfileStatus.updated));
      } catch (e) {
        emit(
          state.copyWith(
            status: ProfileStatus.error,
            error: e is CustomException ? e.apiError : ApiError.unknown(),
          ),
        );
      }
    });

    on<UpdatePasswordEvent>((event, emit) async {
      emit(state.copyWith(status: ProfileStatus.loading));
      try {
        await profileService.updatePassword(password: event.password);
        emit(state.copyWith(status: ProfileStatus.updated));
      } catch (e) {
        emit(
          state.copyWith(
            status: ProfileStatus.error,
            error: e is CustomException ? e.apiError : ApiError.unknown(),
          ),
        );
      }
    });

    on<GetFriendsEvent>(
      (event, emit) async {
        if (event.isRefresh) {
          emit(state.copyWith(status: ProfileStatus.loading));
        } else {
          emit(
            state.copyWith(
              getMoreFriendsStatus: ProfileStatus.loading,
            ),
          );
        }
        try {
          final String? authToken = await AuthTokenHandler().getAuthToken();
          if (authToken == null) {
            emit(
              state.copyWith(
                status: ProfileStatus.error,
                error: AuthError.notAuthenticated(),
              ),
            );
            return;
          }
          final Profile? tmpProfile = state.profile;
          if (tmpProfile != null || event.isOnMap) {
            final GetFriendsPaginationResponse friends =
                await profileRepository.getMyFriends(
              page: event.isRefresh ? 1 : state.friendsPage + 1,
              perPage: state.friendsPerPage,
              position: event.position,
              radius: event.radius,
            );
            emit(
              state.copyWith(
                friends: event.isRefresh
                    ? friends
                    : state.friends.copyWith(
                        data: [
                          ...state.friends.data,
                          ...friends.data,
                        ],
                      ),
                status: ProfileStatus.notLoading,
                getMoreFriendsStatus: ProfileStatus.notLoading,
                friendsPage: event.isRefresh ? 1 : state.friendsPage + 1,
                hasMoreFriends: friends.data.length == state.friendsPerPage,
              ),
            );
          }
        } catch (e) {
          emit(
            state.copyWith(
              status: ProfileStatus.error,
              error: e is CustomException ? e.apiError : ApiError.unknown(),
            ),
          );
        }
      },
    );

    on<UpdateProfilePictureEvent>((event, emit) async {
      try {
        emit(state.copyWith(status: ProfileStatus.loading));
        if (!(event.image.path.endsWith('.png') ||
            event.image.path.endsWith('.jpg') ||
            event.image.path.endsWith('.jpeg'))) {
          emit(
            state.copyWith(
              status: ProfileStatus.error,
              error: FileUploadError.badImageFormat(),
            ),
          );
          return;
        }
        final UploadFile newAvatar =
            await profileService.updateProfilePicture(image: event.image);
        Profile? updatedProfile = state.profile;
        if (updatedProfile != null) {
          updatedProfile = updatedProfile.copyWith(avatar: newAvatar);
        }
        emit(
          state.copyWith(
            status: ProfileStatus.updated,
            profile: updatedProfile,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            status: ProfileStatus.error,
            error: e is CustomException ? e.apiError : ApiError.unknown(),
          ),
        );
      }
    });

    on<UpdateProfileBannerEvent>((event, emit) async {
      try {
        emit(state.copyWith(status: ProfileStatus.loading));
        if (!(event.image.path.endsWith('.png') ||
            event.image.path.endsWith('.jpg') ||
            event.image.path.endsWith('.jpeg'))) {
          emit(
            state.copyWith(
              status: ProfileStatus.error,
              error: FileUploadError.badImageFormat(),
            ),
          );
          return;
        }
        final UploadFile newBanner =
            await profileService.updateProfileBanner(image: event.image);
        Profile? updatedProfile = state.profile;
        if (updatedProfile != null) {
          updatedProfile = updatedProfile.copyWith(banner: newBanner);
        }
        emit(
          state.copyWith(
            status: ProfileStatus.updated,
            profile: updatedProfile,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            status: ProfileStatus.error,
            error: e is CustomException ? e.apiError : ApiError.unknown(),
          ),
        );
      }
    });
  }

  final IProfileService profileService;
}
