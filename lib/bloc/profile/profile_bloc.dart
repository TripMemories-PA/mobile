import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../api/error/api_error.dart';
import '../../api/error/specific_error/auth_error.dart';
import '../../api/exception/custom_exception.dart';
import '../../api/profile/i_profile_service.dart';
import '../../api/profile/response/friends/get_friends_pagination_response.dart';
import '../../local_storage/secure_storage/auth_token_handler.dart';
import '../../object/avatar/avatar.dart';
import '../../object/profile/profile.dart';
import '../../repository/profile_repository.dart';

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
          final Profile profile = await profileRepository.getProfile(authToken);
          emit(
            state.copyWith(
              profile: profile,
              status: ProfileStatus.notLoading,
            ),
          );
          add(GetFriendsEvent(page: 1, perPage: 10));
        } catch (e) {
          // TODO(nono): implement profileLocalDataSource
          /* try {
            final Profile profile =
                await profileRepository.getLocalProfile(event.userId);

            emit(
              state.copyWith(
                profile: profile,
                status: ProfileStatus.error,
                error: e is CustomException ? e.apiError : ApiError.unknown(),
              ),
            );
          } catch (_) {*/
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
      await profileService.updatePassword(password: event.password);
    });

    on<GetFriendsEvent>(
      (event, emit) async {
        emit(state.copyWith(status: ProfileStatus.loading));
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
          final GetFriendsPaginationResponse friends =
              await profileRepository.getFriends(
            id: authToken,
            page: event.page,
            perPage: event.perPage,
          );
          emit(
            state.copyWith(
              friends: friends,
              status: ProfileStatus.notLoading,
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
      },
    );

    on<UpdateProfilePictureEvent>((event, emit) async {
      try {
        emit(state.copyWith(status: ProfileStatus.loading));
        final UploadFile newPicture = await profileService.updateProfilePicture(image: event.image);
        Profile? updatedProfile = state.profile;
        if (updatedProfile != null) {
          updatedProfile = updatedProfile.copyWith(avatar: newPicture);
        }
        emit(state.copyWith(status: ProfileStatus.updated, profile: updatedProfile));
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
