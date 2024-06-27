import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/error/api_error.dart';
import '../../api/error/specific_error/auth_error.dart';
import '../../api/exception/custom_exception.dart';
import '../../api/profile/i_profile_service.dart';
import '../../api/profile/response/friend_request/friend_request_response.dart';
import '../../api/profile/response/friends/get_friends_pagination_response.dart';
import '../../local_storage/secure_storage/auth_token_handler.dart';
import '../../object/friend_request/friend_request.dart';
import '../../repository/profile/profile_repository.dart';

part 'friend_request_event.dart';
part 'friend_request_state.dart';

class FriendRequestBloc extends Bloc<FriendRequestEvent, FriendRequestState> {
  FriendRequestBloc({
    required ProfileRepository profileRepository,
    required this.profileService,
  }) : super(const FriendRequestState()) {
    on<GetFriendRequestEvent>((event, emit) async {
      if (event.isRefresh) {
        emit(state.copyWith(status: FriendRequestStatus.loading));
      }
      try {
        final String? authToken = await AuthTokenHandler().getAuthToken();
        if (authToken == null) {
          emit(
            state.copyWith(
              status: FriendRequestStatus.error,
              error: AuthError.notAuthenticated(),
            ),
          );
          return;
        }
        final GetFriendRequestResponse friendRequests =
            await profileRepository.getMyFriendRequests(
          page: event.isRefresh ? 1 : state.friendsPage + 1,
          perPage: state.friendsPerPage,
        );
        emit(
          state.copyWith(
            friendRequests: event.isRefresh
                ? friendRequests
                : state.friendRequests?.copyWith(
                    data: [
                      ...state.friendRequests!.data,
                      ...friendRequests.data,
                    ],
                  ),
            status: FriendRequestStatus.notLoading,
            friendsPage: event.isRefresh ? 1 : state.friendsPage + 1,
            hasMoreTweets: friendRequests.data.length == state.friendsPerPage,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            status: FriendRequestStatus.error,
            error: e is CustomException ? e.apiError : ApiError.unknown(),
          ),
        );
      }
    });

    on<AcceptFriendRequestEvent>((event, emit) async {
      try {
        await profileService.acceptFriendRequest(
          friendRequestId: event.friendRequestId,
        );
        List<FriendRequest>? friendRequests = state.friendRequests?.data;

        if (friendRequests != null) {
          friendRequests = List<FriendRequest>.from(friendRequests);

          friendRequests.removeWhere(
            (element) => element.id.toString() == event.friendRequestId,
          );
        }
        GetFriendRequestResponse? friendRequestsResponse = state.friendRequests;
        if (friendRequests != null && friendRequestsResponse != null) {
          friendRequestsResponse =
              friendRequestsResponse.copyWith(data: friendRequests);
        }
        emit(
          state.copyWith(
            status: FriendRequestStatus.accepted,
            friendRequests: friendRequestsResponse,
          ),
        );
        add(GetFriendRequestEvent(isRefresh: true));
      } catch (e) {
        emit(
          state.copyWith(
            status: FriendRequestStatus.error,
            error: e is CustomException ? e.apiError : ApiError.unknown(),
          ),
        );
      }
    });

    on<RejectFriendRequestEvent>((event, emit) async {
      try {
        await profileService.rejectFriendRequest(
          friendRequestId: event.friendRequestId,
        );
        List<FriendRequest>? friendRequests = state.friendRequests?.data;

        if (friendRequests != null) {
          friendRequests = List<FriendRequest>.from(friendRequests);

          friendRequests.removeWhere(
            (element) => element.id.toString() == event.friendRequestId,
          );
        }
        GetFriendRequestResponse? friendRequestsResponse = state.friendRequests;
        if (friendRequests != null && friendRequestsResponse != null) {
          friendRequestsResponse =
              friendRequestsResponse.copyWith(data: friendRequests);
        }
        emit(
          state.copyWith(
            status: FriendRequestStatus.refused,
            friendRequests: friendRequestsResponse,
          ),
        );
        add(GetFriendRequestEvent(isRefresh: true));
      } catch (e) {
        emit(
          state.copyWith(
            status: FriendRequestStatus.error,
            error: e is CustomException ? e.apiError : ApiError.unknown(),
          ),
        );
      }
    });


    on<DeleteFriendEvent>((event, emit) async {
      try {
        emit(state.copyWith(status: FriendRequestStatus.loading));
        await profileService.removeFriend(friendId: event.friendId);
        emit(state.copyWith(status: FriendRequestStatus.friendShipDeleted));
      } catch (e) {
        emit(
          state.copyWith(
            status: FriendRequestStatus.error,
            error: e is CustomException ? e.apiError : ApiError.unknown(),
          ),
        );
      }
    });

  }

  final IProfileService profileService;
}
