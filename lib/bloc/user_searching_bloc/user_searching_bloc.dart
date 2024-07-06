import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/error/api_error.dart';
import '../../api/error/specific_error/auth_error.dart';
import '../../api/exception/custom_exception.dart';
import '../../api/profile/i_profile_service.dart';
import '../../api/profile/response/get_friends_pagination_response.dart';
import '../../local_storage/secure_storage/auth_token_handler.dart';
import '../../repository/profile/i_profile_repository.dart';

part 'user_searching_event.dart';
part 'user_searching_state.dart';

class UserSearchingBloc extends Bloc<UserSearchingEvent, UserSearchingState> {
  UserSearchingBloc({
    required this.profileRepository,
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
        await profileService.sendFriendRequest(
          userId: event.userId,
        );
        emit(
          state.copyWith(
            status: UserSearchingStatus.requestSent,
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

    on<SearchUsersEvent>((event, emit) async {
      try {
        emit(
          state.copyWith(
            searchingUserByNameStatus: UserSearchingStatus.loading,
          ),
        );
        final GetFriendsPaginationResponse users =
            await profileRepository.getUsers(
          page: event.isRefresh ? 1 : state.searchUsersPage + 1,
          perPage: state.searchUsersPerPage,
          searchName: event.searchingCriteria,
        );
        emit(
          state.copyWith(
            searchingUserByNameStatus: UserSearchingStatus.notLoading,
            usersSearchByName: event.isRefresh
                ? users
                : state.usersSearchByName?.copyWith(
                    data: [
                      ...state.usersSearchByName!.data,
                      ...users.data,
                    ],
                  ),
            searchUsersPage: event.isRefresh ? 1 : state.searchUsersPage + 1,
            searchUsersHasMoreUsers:
                users.data.length == state.searchUsersPerPage,
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
  }

  final IProfileService profileService;
  final IProfileRepository profileRepository;
}
