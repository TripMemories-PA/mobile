import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../../api/profile/profile_service.dart';
import '../../bloc/user_searching_bloc/user_searching_bloc.dart';
import '../../constants/my_colors.dart';
import '../../constants/string_constants.dart';
import '../../num_extensions.dart';
import '../../repository/profile/profile_repository.dart';
import '../../utils/messenger.dart';
import '../custom_card.dart';
import '../search_bar_custom.dart';
import '../shimmer/shimmer_post_and_monument_resume_grid.dart';
import '../user_list.dart';

class UserSearching extends HookWidget {
  const UserSearching({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
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
                borderColor: Colors.transparent,
                width: MediaQuery.of(context).size.width * 0.90,
                height: MediaQuery.of(context).size.height * 0.81,
                content: SizedBox.expand(
                  child: Stack(
                    children: [
                      const SearchingUsersBody(),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: IconButton(
                          onPressed: () => context.pop(),
                          icon: const Icon(Icons.close),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
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
            SearchBarCustom(
              searchController: searchController,
              context: context,
              searching: searching,
              searchContent: searchContent,
              hintText: StringConstants().searchFriends,
              onSearch: (value) {
                context.read<UserSearchingBloc>().add(
                      SearchUsersEvent(
                        isRefresh: true,
                        searchingCriteria: value,
                      ),
                    );
              },
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
                    Text(StringConstants().or),
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
          return Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.90,
              height: MediaQuery.of(context).size.height * 0.30,
              child: const ShimmerPostAndMonumentResumeGrid(),
            ),
          );
        } else if (state.usersSearchByName?.data == null) {
          return Text(StringConstants().noUserFound);
        } else {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${state.usersSearchByName!.data.length} ${StringConstants().result}${state.usersSearchByName!.data.length > 1 ? 's' : ''}',
                    style: const TextStyle(
                      color: MyColors.darkGrey,
                    ),
                  ),
                ),
              ),
              UserList(
                users: state.usersSearchByName?.data ?? [],
                needToPop: true,
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
                            child: Text(StringConstants().showMoreResults),
                          )
                        : _buildErrorWidget(context))
                    : Text(StringConstants().noMoreUsers),
              ),
              if (state.searchingUserByNameStatus ==
                  UserSearchingStatus.loading)
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.90,
                  height: MediaQuery.of(context).size.height * 0.30,
                  child: const ShimmerPostAndMonumentResumeGrid(),
                ),
            ],
          );
        }
      },
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
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          StringConstants().addFriends,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildUserList(BuildContext context) {
    return BlocBuilder<UserSearchingBloc, UserSearchingState>(
      builder: (context, state) {
        return Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                StringConstants().youCouldKnow,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            UserList(
              users: context.read<UserSearchingBloc>().state.users?.data ?? [],
              needToPop: true,
            ),
            Center(
              child: context.read<UserSearchingBloc>().state.hasMoreUsers
                  ? (context.read<UserSearchingBloc>().state.status !=
                          UserSearchingStatus.error
                      ? Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.90,
                            height: MediaQuery.of(context).size.height * 0.20,
                            child: const ShimmerPostAndMonumentResumeGrid(),
                          ),
                        )
                      : _buildErrorWidget(context))
                  : Text(StringConstants().noMoreUsers),
            ),
            BlocListener<UserSearchingBloc, UserSearchingState>(
              listener: (context, state) {
                if (state.status == UserSearchingStatus.requestSent) {
                  Messenger.showSnackBarQuickInfo(
                    StringConstants().friendRequestSent,
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
