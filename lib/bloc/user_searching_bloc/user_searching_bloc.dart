import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/error/api_error.dart';
import '../../api/error/specific_error/auth_error.dart';
import '../../api/exception/custom_exception.dart';
import '../../api/profile/i_profile_service.dart';
import '../../api/profile/response/friends/get_friends_pagination_response.dart';
import '../../local_storage/secure_storage/auth_token_handler.dart';
import '../../object/profile/profile.dart';
import '../../repository/profile_repository.dart';

part 'user_searching_event.dart';
part 'user_searching_state.dart';

class UserSearchingBloc extends Bloc<UserSearchingEvent, UserSearchingState> {
  UserSearchingBloc({
    required ProfileRepository profileRepository,
    required this.profileService,
  }) : super(const UserSearchingState()) {
    on<GetUsersRequestEvent>((event, emit) async {
      if (event.isRefresh) {
        emit(state.copyWith(status: UserSearchingStatus.loading));
      }
      try {
        final String? authToken = await AuthTokenHandler().getAuthToken();
        if (authToken == null) {
          emit(
            state.copyWith(
              status: UserSearchingStatus.error,
              error: AuthError.notAuthenticated(),
            ),
          );
          return;
        }
        final GetFriendsPaginationResponse users =
            await profileRepository.getUsers(
          page: event.isRefresh ? 1 : state.friendsPage + 1,
          perPage: state.friendsPerPage,
        );
        emit(
          state.copyWith(
            users: event.isRefresh
                ? users
                : state.users?.copyWith(
                    data: [
                      ...state.users!.data,
                      ...users.data,
                    ],
                  ),
            status: UserSearchingStatus.notLoading,
            friendsPage: event.isRefresh ? 1 : state.friendsPage + 1,
            hasMoreUsers: users.data.length == state.friendsPerPage,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            status: UserSearchingStatus.error,
            error: e is CustomException ? e.apiError : ApiError.unknown(),
          ),
        );
      }
    });

    on<SendFriendRequestEvent>((event, emit) async {
      try {
        await profileService.acceptFriendRequest(
          friendRequestId: event.userId,
        );
        List<Profile>? users = state.users?.data;

        if (users != null) {
          users = List<Profile>.from(users);

          users.removeWhere(
            (element) => element.id.toString() == event.userId,
          );
        }
        GetFriendsPaginationResponse? usersResponse = state.users;
        if (users != null && usersResponse != null) {
          usersResponse = usersResponse.copyWith(data: users);
        }
        emit(
          state.copyWith(
            status: UserSearchingStatus.requestSent,
            users: usersResponse,
          ),
        );
        add(GetUsersRequestEvent(isRefresh: true));
      } catch (e) {
        emit(
          state.copyWith(
            status: UserSearchingStatus.error,
            error: e is CustomException ? e.apiError : ApiError.unknown(),
          ),
        );
      }
    });
  }

  final IProfileService profileService;
}
