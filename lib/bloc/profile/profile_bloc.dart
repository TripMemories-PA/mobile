import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/error/api_error.dart';
import '../../api/exception/custom_exception.dart';
import '../../api/profile/i_profile_service.dart';
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
          final Profile profile =
              await profileRepository.getProfile(event.userId);
          emit(
            state.copyWith(
              profile: profile,
              status: ProfileStatus.notLoading,
            ),
          );
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
      await profileService.updateProfile(
        userName: event.userName,
        lastName: event.lastName,
        firstName: event.firstName,
        email: event.email,
      );
    });

    on<UpdatePasswordEvent>((event, emit) async {
      await profileService.updatePassword(password: event.password);
    });
  }

  final IProfileService profileService;
}
