import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../../api/profile/profile_service.dart';
import '../../bloc/user_searching_bloc/user_searching_bloc.dart';
import '../../constants/my_colors.dart';
import '../../constants/route_name.dart';
import '../../constants/string_constants.dart';
import '../../num_extensions.dart';
import '../../object/profile/profile.dart';
import '../../repository/profile_repository.dart';
import '../../service/profile_remote_data_source.dart';
import '../../utils/messenger.dart';
import '../custom_card.dart';

class UserSearching extends HookWidget {
  const UserSearching({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<ProfileRepository>(
      create: (context) => ProfileRepository(
        profileRemoteDataSource: ProfileRemoteDataSource(),
        // TODO(nono): Implement ProfileLocalDataSource
        //profilelocalDataSource: ProfileLocalDataSource(),
      ),
      child: BlocProvider(
        create: (context) => UserSearchingBloc(
          profileRepository: RepositoryProvider.of<ProfileRepository>(context),
          profileService: ProfileService(),
        )..add(GetUsersRequestEvent(isRefresh: true)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Builder(
            builder: (context) {
              return Dialog(
                insetPadding: EdgeInsets.zero,
                child: CustomCard(
                  width: MediaQuery.of(context).size.width * 0.90,
                  height: MediaQuery.of(context).size.height * 0.81,
                  content: const SizedBox.expand(
                    child: SearchingUsersBody(),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

Future<bool> userSearchingPopup(
  BuildContext context,
) async {
  return await showDialog<bool>(
        context: context,
        builder: (_) => const UserSearching(),
      ) ??
      false;
}

class SearchingUsersBody extends HookWidget {
  const SearchingUsersBody({super.key});

  void _getUsers(BuildContext context) {
    final tweetBloc = context.read<UserSearchingBloc>();

    if (tweetBloc.state.status != UserSearchingStatus.loading) {
      tweetBloc.add(
        GetUsersRequestEvent(isRefresh: false),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = useTextEditingController();
    final searching = useState(false);
    final searchContent = useState('');
    final ScrollController usersScrollController = useScrollController();
    useEffect(
      () {
        void createScrollListener() {
          if (usersScrollController.position.atEdge) {
            if (usersScrollController.position.pixels != 0) {
              _getUsers(context);
            }
          }
        }

        usersScrollController.addListener(createScrollListener);
        return () => usersScrollController.removeListener(createScrollListener);
      },
      const [],
    );
    return SingleChildScrollView(
      controller: usersScrollController,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            _buildTitle(
              context,
              searching,
              searchController,
              searchContent,
            ),
            _buildSearchBar(
              searchController,
              context,
              searching,
              searchContent,
            ),
            10.ph,
            if (searching.value) _buildSearchUserList(searchContent),
            if (searching.value)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 3,
                      width: MediaQuery.of(context).size.width * 0.30,
                      decoration: const BoxDecoration(
                        color: MyColors.lightGrey,
                      ),
                    ),
                    15.pw,
                    const Text('ou'),
                    15.pw,
                    Container(
                      height: 3,
                      width: MediaQuery.of(context).size.width * 0.30,
                      decoration: const BoxDecoration(
                        color: MyColors.lightGrey,
                      ),
                    ),
                  ],
                ),
              ),
            _buildUserList(context),
          ],
        ),
      ),
    );
  }

  BlocBuilder<UserSearchingBloc, UserSearchingState> _buildSearchUserList(
    ValueNotifier<String> searchContent,
  ) {
    return BlocBuilder<UserSearchingBloc, UserSearchingState>(
      builder: (context, state) {
        if (state.status == UserSearchingStatus.error) {
          return _buildErrorWidget(context);
        } else if (state.searchingUserByNameStatus ==
            UserSearchingStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.usersSearchByName?.data == null) {
          return const Text('Aucun utilisateur trouvé');
        } else {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${state.usersSearchByName!.data.length} résultat${state.usersSearchByName!.data.length > 1 ? 's' : ''}',
                    style: const TextStyle(
                      color: MyColors.darkGrey,
                    ),
                  ),
                ),
              ),
              Wrap(
                spacing: 10.0,
                runSpacing: 10.0,
                children: [
                  ...state.usersSearchByName?.data
                          .map(
                            (friend) => Column(
                              key: ObjectKey(friend),
                              children: [
                                _buildUserCard(context, friend),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          )
                          .toList() ??
                      [],
                ],
              ),
              Center(
                child: state.searchUsersHasMoreUsers
                    ? (state.searchingUserByNameStatus !=
                            UserSearchingStatus.error
                        ? ElevatedButton(
                            onPressed: () {
                              context.read<UserSearchingBloc>().add(
                                    SearchUsersEvent(
                                      isRefresh: false,
                                      searchingCriteria: searchContent.value,
                                    ),
                                  );
                            },
                            child: const Text('Voir plus de résultats'),
                          )

                        // TODO(nono): SHIMMER
                        : _buildErrorWidget(context))
                    : Text(StringConstants().noMoreUsers),
              ),
            ],
          );
        }
      },
    );
  }

  Container _buildSearchBar(
    TextEditingController searchController,
    BuildContext context,
    ValueNotifier<bool> searching,
    ValueNotifier<String> searchContent,
  ) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: MyColors.darkGrey),
      ),
      child: ValueListenableBuilder(
        valueListenable: searchContent,
        builder: (context, value, child) {
          return TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Rechercher des amis',
              suffixIcon: value.isEmpty
                  ? Icon(
                      Icons.search,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  : IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        searchContent.value = '';
                        searchController.clear();
                        searching.value = false;
                      },
                      icon: const Icon(
                        Icons.close,
                        size: 20,
                      ),
                    ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(10.0),
            ),
            onChanged: (value) {
              value.isEmpty ? searching.value = false : searching.value = true;
              searchContent.value = value;
              context.read<UserSearchingBloc>().add(
                    SearchUsersEvent(
                      isRefresh: true,
                      searchingCriteria: value,
                    ),
                  );
            },
          );
        },
      ),
    );
  }

  Widget _buildTitle(
    BuildContext context,
    ValueNotifier<bool> searching,
    TextEditingController searchController,
    ValueNotifier<String> searchContent,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 10.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Ajouter des amis',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 25,
                child: ElevatedButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: const Text('Fermer'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserList(BuildContext context) {
    return BlocBuilder<UserSearchingBloc, UserSearchingState>(
      builder: (context, state) {
        return Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Vous pourriez connaître...',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              children: context
                      .read<UserSearchingBloc>()
                      .state
                      .users
                      ?.data
                      .map(
                        (friend) => _buildUserCard(context, friend),
                      )
                      .toList() ??
                  [],
            ),
            Center(
              child: context.read<UserSearchingBloc>().state.hasMoreUsers
                  ? (context.read<UserSearchingBloc>().state.status !=
                          UserSearchingStatus.error
                      ? const Text('SHIMMER HERe')
                      // TODO(nono): SHIMMER
                      : _buildErrorWidget(context))
                  : Text(StringConstants().noMoreUsers),
            ),
            BlocListener<UserSearchingBloc, UserSearchingState>(
              listener: (context, state) {
                if (state.status == UserSearchingStatus.requestSent) {
                  Messenger.showSnackBarQuickInfo(
                    "Demande d'ami envoyée",
                    context,
                  );
                }
              },
              child: const SizedBox.shrink(),
            ),
          ],
        );
      },
    );
  }

  CustomCard _buildUserCard(
    BuildContext context,
    Profile user,
  ) {
    final String? avatarUrl = user.avatar?.url;
    return CustomCard(
      width: 165,
      height: 150,
      borderColor: MyColors.lightGrey,
      content: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildUserPhoto(avatarUrl, context, user.id.toString()),
            Row(
              children: [
                SizedBox(
                  width: 115,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${user.firstname} '
                        '${user.lastname}',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '@${user.username}',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const Expanded(child: SizedBox()),
                Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                    color: MyColors.purple,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    iconSize: 15,
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.person_add_outlined),
                    color: Colors.white,
                    onPressed: () {
                      context.read<UserSearchingBloc>().add(
                            SendFriendRequestEvent(
                              userId: user.id.toString(),
                            ),
                          );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Stack _buildUserPhoto(
      String? avatarUrl, BuildContext context, String userId) {
    return Stack(
      children: [
        Container(
          width: 160,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: avatarUrl != null
              ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: avatarUrl,
                    fit: BoxFit.cover,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Center(
                      child: CircularProgressIndicator(
                        value: downloadProgress.progress,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: MyColors.lightGrey,
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.grey,
                  ),
                ),
        ),
        Positioned(
          top: 10,
          left: 10,
          child: Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
              border: Border.fromBorderSide(
                BorderSide(),
              ),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              iconSize: 10,
              icon: const Icon(Icons.remove_red_eye_outlined),
              color: Colors.black,
              onPressed: () {
                context.push('${RouteName.profilePage}/$userId');
                context.pop();
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorWidget(BuildContext context) {
    return Column(
      children: [
        Text(StringConstants().errorAppendedWhileGettingData),
        ElevatedButton(
          onPressed: () => _getUsersRequest(context),
          child: Text(StringConstants().retry),
        ),
      ],
    );
  }

  void _getUsersRequest(BuildContext context) {
    context.read<UserSearchingBloc>().add(
          GetUsersRequestEvent(isRefresh: true),
        );
  }
}
