import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../api/profile/profile_service.dart';
import '../bloc/auth_bloc/auth_bloc.dart';
import '../bloc/auth_bloc/auth_state.dart';
import '../bloc/cart/cart_bloc.dart';
import '../bloc/friend_request_bloc/friend_request_bloc.dart';
import '../bloc/profile/profile_bloc.dart';
import '../bloc/user_searching_bloc/user_searching_bloc.dart';
import '../constants/route_name.dart';
import '../constants/string_constants.dart';
import '../num_extensions.dart';
import '../object/profile.dart';
import '../repository/profile/profile_repository.dart';
import '../utils/messenger.dart';
import 'custom_card.dart';
import 'friends_and_visited_widget.dart';
import 'popup/confirmation_dialog.dart';
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
                                  child: Row(
                                    children: [
                                      _buildProfileActionButton(context),
                                      if (isMyProfile) const Spacer(),
                                      if (isMyProfile) _buildShopButton(),
                                    ],
                                  ),
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

  BlocBuilder<CartBloc, CartState> _buildShopButton() {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        final int total = context.read<CartBloc>().state.cartElements.fold(
              0,
              (previousValue, element) =>
                  previousValue + element.articles.length,
            );
        return Stack(
          children: [
            IconButton(
              icon: const Icon(
                Icons.shopping_cart_outlined,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (
                    BuildContext context,
                  ) {
                    return _buildCart();
                  },
                );
              },
            ),
            Positioned(
              left: 0,
              child: Container(
                padding: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(
                    6,
                  ),
                ),
                constraints: const BoxConstraints(
                  minWidth: 15,
                  minHeight: 15,
                ),
                child: Text(
                  '$total',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Dialog _buildCart() {
    return Dialog(
      insetPadding: const EdgeInsets.all(10),
      child: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          return Container(
            width: MediaQuery.of(context).size.width * 0.90,
            height: MediaQuery.of(context).size.height * 0.90,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              border: Border.fromBorderSide(
                BorderSide(),
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20.0,
                      horizontal: 20,
                    ),
                    child: Column(
                      children: [
                        10.ph,
                        Row(
                          children: [
                            Text(
                              StringConstants().cart,
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {
                                context.pop();
                              },
                              icon: const Icon(
                                Icons.close,
                              ),
                            ),
                          ],
                        ),
                        20.ph,
                        SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              for (final cartElement in context
                                  .read<CartBloc>()
                                  .state
                                  .cartElements)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10.0,
                                  ),
                                  child:
                                      _buildArticleCart(context, cartElement),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  _buildFooter(context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Container _buildFooter(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          children: [
            const Spacer(),
            Row(
              children: [
                Text(
                  StringConstants().total,
                  style: TextStyle(
                    fontSize: 30,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
                const Spacer(),
                Text(
                  '${context.read<CartBloc>().state.totalPrice} €',
                  style: TextStyle(
                    fontSize: 30,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Container(
              width: double.infinity,
              height: 1,
              color: Theme.of(context).colorScheme.surface,
            ),
            const Spacer(),
            CustomCard(
              onTap: () {
                context.pop();
                context.push(
                  RouteName.buy,
                  extra: context.read<CartBloc>(),
                );
              },
              borderRadius: 30,
              borderColor: Colors.transparent,
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  StringConstants().buy,
                  style: TextStyle(
                    fontSize: 15,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  CustomCard _buildArticleCart(BuildContext context, CartElement cartElement) {
    return CustomCard(
      borderColor: Theme.of(context).colorScheme.tertiary,
      height: 120,
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                10.ph,
                _buildTicketHeader(context),
                Row(
                  children: [
                    Checkbox(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      value: true,
                      onChanged: (value) {},
                      activeColor: Theme.of(context).colorScheme.primary,
                      checkColor: Colors.white,
                      side: WidgetStateBorderSide.resolveWith(
                        (Set<WidgetState> states) {
                          if (states.contains(WidgetState.selected)) {
                            return null;
                          }
                          return BorderSide(
                            color: Theme.of(context).colorScheme.tertiary,
                          );
                        },
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cartElement.articles[0].title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          cartElement.articles[0].poi.name.toUpperCase(),
                        ),
                        Text(
                          cartElement.articles[0].poi.type.name,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Container(
                height: 80,
                width: 1,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    textAlign: TextAlign.center,
                    '${cartElement.articles[0].price} €',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Container(
                    height: 30,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        5.pw,
                        SizedBox(
                          height: 25,
                          width: 25,
                          child: IconButton(
                            onPressed: () => {
                              context.read<CartBloc>().add(
                                    RemoveArticle(
                                      cartElement.articles[0],
                                    ),
                                  ),
                            },
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                Colors.transparent,
                              ),
                              shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              side: WidgetStateBorderSide.resolveWith(
                                (Set<WidgetState> states) {
                                  return BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  );
                                },
                              ),
                            ),
                            icon: Icon(
                              Icons.remove,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${cartElement.articles.length}',
                        ),
                        const Spacer(),
                        SizedBox(
                          height: 25,
                          width: 25,
                          child: IconButton(
                            onPressed: () => {
                              context.read<CartBloc>().add(
                                    AddArticle(
                                      cartElement.articles[0],
                                    ),
                                  ),
                            },
                            icon: const Icon(
                              Icons.add,
                            ),
                          ),
                        ),
                        5.pw,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row _buildTicketHeader(BuildContext context) {
    return Row(
      children: [
        10.pw,
        Container(
          height: 25,
          width: 25,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              10,
            ),
          ),
          child: Image.asset(
            'assets/images/ticket.png',
          ),
        ),
        10.pw,
        Text(
          StringConstants().tickets,
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
      ],
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
