import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../api/profile/profile_service.dart';
import '../bloc/auth_bloc/auth_bloc.dart';
import '../bloc/auth_bloc/auth_state.dart';
import '../bloc/friend_request_bloc/friend_request_bloc.dart';
import '../bloc/profile/profile_bloc.dart';
import '../bloc/user_searching_bloc/user_searching_bloc.dart';
import '../constants/string_constants.dart';
import '../num_extensions.dart';
import '../object/profile/profile.dart';
import '../repository/profile/profile_repository.dart';
import '../utils/messenger.dart';
import 'friends_and_visited_widget.dart';
import 'popup/confirmation_logout_dialog.dart';
import 'popup/modify_user_infos_popup.dart';
import 'popup/my_friends_requests.dart';

class ProfileBanner extends StatelessWidget {
  const ProfileBanner({
    super.key,
    this.isMyProfile = false,
  });

  final bool isMyProfile;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Column(
                children: [
                  10.ph,
                  MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) => FriendRequestBloc(
                          profileRepository:
                              RepositoryProvider.of<ProfileRepository>(context),
                          profileService: ProfileService(),
                        ),
                      ),
                      BlocProvider(
                        create: (context) => UserSearchingBloc(
                          profileRepository:
                              RepositoryProvider.of<ProfileRepository>(context),
                          profileService: ProfileService(),
                        ),
                      ),
                    ],
                    child: BlocBuilder<FriendRequestBloc, FriendRequestState>(
                      builder: (context, state) {
                        return BlocBuilder<UserSearchingBloc,
                            UserSearchingState>(
                          builder: (context, state) {
                            return Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: MultiBlocListener(
                                  listeners: [
                                    BlocListener<FriendRequestBloc,
                                        FriendRequestState>(
                                      listener: (context, state) {
                                        if (state.status ==
                                            FriendRequestStatus.accepted) {
                                          context.read<ProfileBloc>().add(
                                                GetProfileEvent(
                                                  userId: context
                                                      .read<ProfileBloc>()
                                                      .state
                                                      .profile
                                                      ?.id,
                                                ),
                                              );
                                        } else if (state.status ==
                                            FriendRequestStatus
                                                .friendShipDeleted) {
                                          context.read<ProfileBloc>().add(
                                                GetProfileEvent(
                                                  userId: context
                                                      .read<ProfileBloc>()
                                                      .state
                                                      .profile
                                                      ?.id,
                                                ),
                                              );
                                          Messenger.showSnackBarQuickInfo(
                                            StringConstants().friendDeleted,
                                            context,
                                          );
                                        }
                                      },
                                    ),
                                    BlocListener<UserSearchingBloc,
                                        UserSearchingState>(
                                      listener: (context, state) {
                                        if (state.status ==
                                            UserSearchingStatus.requestSent) {
                                          context.read<ProfileBloc>().add(
                                                GetProfileEvent(
                                                  userId: context
                                                      .read<ProfileBloc>()
                                                      .state
                                                      .profile
                                                      ?.id,
                                                ),
                                              );
                                          Messenger.showSnackBarQuickInfo(
                                            StringConstants().friendRequestSent,
                                            context,
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                  child: _buildProfileActionButton(context),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Text(
                    '${context.read<ProfileBloc>().state.profile?.firstname ?? 'User'} ${context.read<ProfileBloc>().state.profile?.lastname ?? context.read<ProfileBloc>().state.profile?.id.toString()}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '@${context.read<ProfileBloc>().state.profile?.username}',
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                  FriendsAndVisitedWidget(
                    itIsMe: isMyProfile,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileActionButton(BuildContext context) {
    final Profile? profile = context.read<ProfileBloc>().state.profile;
    final bool imLoggedIn =
        context.read<AuthBloc>().state.status == AuthStatus.authenticated;
    if (profile == null || !imLoggedIn) {
      return Container(
        height: 30,
      );
    } else {
      Icon? icon;
      Widget? widgetToDisplay;
      Function() onPressed = () {};
      if (isMyProfile) {
        icon = Icon(
          Icons.edit_outlined,
          color: Theme.of(context).colorScheme.primary,
        );
        onPressed = () async {
          await modifyUserInfosPopup(context);
        };
      } else {
        if (profile.isFriend ?? false) {
          icon = Icon(
            Icons.person_remove_outlined,
            color: Theme.of(context).colorScheme.primary,
          );
          onPressed = () async {
            confirmationPopUp(
              context,
              title: StringConstants().sureToDeleteAccount,
            ).then((bool result) {
              if (result) {
                context
                    .read<FriendRequestBloc>()
                    .add(DeleteFriendEvent(profile.id));
              }
            });
          };
        } else if (profile.hasReceivedFriendRequest ?? false) {
          widgetToDisplay = SizedBox(
            width: 110,
            child: Text(
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              StringConstants().friendRequestSent,
            ),
          );
          onPressed = () {};
        } else if (profile.hasSentFriendRequest ?? false) {
          widgetToDisplay = SizedBox(
            width: MediaQuery.of(context).size.width * 0.30,
            child: Column(
              children: [
                Text(
                  StringConstants().friendRequestReceived,
                  textAlign: TextAlign.center,
                ),
                10.ph,
                ElevatedButton(
                  onPressed: () async {
                    await myFriendsRequestsPopup(context);
                  },
                  child: AutoSizeText(
                    StringConstants().seeMyFriendRequests,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          );
          onPressed = () {};
        } else {
          icon = Icon(
            Icons.person_add_outlined,
            color: Theme.of(context).colorScheme.primary,
          );
          onPressed = () {
            context
                .read<UserSearchingBloc>()
                .add(SendFriendRequestEvent(userId: profile.id.toString()));
          };
        }
      }
      return icon != null
          ? Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                ),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    Colors.transparent,
                  ),
                ),
                onPressed: () => onPressed(),
                icon: icon,
              ),
            )
          : (widgetToDisplay ?? Container());
    }
  }
}
