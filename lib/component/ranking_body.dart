import 'dart:math' as math;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../bloc/user_searching_bloc/user_searching_bloc.dart';
import '../component/custom_card.dart';
import '../component/profile_picture.dart';
import '../constants/route_name.dart';
import '../constants/string_constants.dart';
import '../num_extensions.dart';
import '../object/profile.dart';

class RankingBody extends HookWidget {
  const RankingBody({
    super.key,
    required this.rankingScrollController,
  });

  final ScrollController rankingScrollController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserSearchingBloc, UserSearchingState>(
      builder: (context, state) {
        final List<Profile>? users =
            context.read<UserSearchingBloc>().state.users?.data;
        if (state.status == UserSearchingStatus.loading) {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            body: Center(
              child: Lottie.asset(
                'assets/lottie/plane_loader.json',
              ),
            ),
          );
        }
        if (users == null) {
          return Text(StringConstants().noData);
        }
        if (state.status == UserSearchingStatus.error) {
          return _buildErrorWidget(context);
        } else if (users.isEmpty) {
          return Text(StringConstants().noUserFound);
        } else {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            body: Stack(
              children: [
                DefaultTabController(
                  length: 1,
                  child: NestedScrollView(
                    headerSliverBuilder: (context, value) {
                      return [
                        _buildHeader(context, state),
                        _buildSliverMenu(context),
                      ];
                    },
                    body: TabBarView(
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0,
                                ),
                                child: CustomCard(
                                  content: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        for (int i = 0; i < users.length; i++)
                                          Column(
                                            children: [
                                              _buildUserRankingCard(
                                                  context, users[i], i),
                                              10.ph,
                                            ],
                                          ),
                                        _buildLoadMore(context),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildLoadMore(BuildContext context) {
    final state = context.read<UserSearchingBloc>().state;

    if (state.searchingUserByNameStatus == UserSearchingStatus.loading) {
      return const CircularProgressIndicator();
    } else if (state.hasMoreUsers) {
      return ElevatedButton(
        onPressed: () => _getRankingRequest(
          context,
          false,
        ),
        child: Text(StringConstants().loadMoreResults),
      );
    } else {
      return Text(StringConstants().noMoreUsers);
    }
  }

  InkWell _buildUserRankingCard(
    BuildContext context,
    Profile user,
    int i,
  ) {
    return InkWell(
      onTap: () => context.push(
        '${RouteName.profilePage}/${user.id}',
      ),
      child: CustomCard(
        height: 75,
        content: Row(
          children: [
            10.pw,
            getTropheeIcon(i)!,
            15.pw,
            SizedBox(
              width: 40,
              height: 40,
              child: ProfilePicture(
                uploadedFile: user.avatar,
              ),
            ),
            15.pw,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  10.ph,
                  AutoSizeText(
                    textAlign: TextAlign.left,
                    user.username,
                    style: const TextStyle(fontSize: 20),
                    maxLines: 1,
                    minFontSize: 10,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AutoSizeText(
                    textAlign: TextAlign.left,
                    '${user.score} ${StringConstants().points}',
                    style: const TextStyle(fontSize: 15),
                    maxLines: 1,
                    minFontSize: 10,
                    overflow: TextOverflow.ellipsis,
                  ),
                  10.ph,
                ],
              ),
            ),
            10.pw,
          ],
        ),
      ),
    );
  }

  Image? getTropheeIcon(int i) {
    switch (i) {
      case 0:
        return Image.asset('assets/images/gold_trophee.png');
      case 1:
        return Image.asset('assets/images/silver_trophee.png');
      case 2:
        return Image.asset('assets/images/bronze_trophee.png');
      default:
        return Image.asset('assets/images/black_trophee.png');
    }
  }

  Widget _buildErrorWidget(BuildContext context) {
    return Column(
      children: [
        Text(StringConstants().errorAppendedWhileGettingData),
        ElevatedButton(
          onPressed: () => _getRankingRequest(
            context,
            true,
          ),
          child: Text(StringConstants().retry),
        ),
      ],
    );
  }

  void _getRankingRequest(BuildContext context, bool isRefresh) {
    context.read<UserSearchingBloc>().add(
          GetUsersRanking(
            isRefresh: isRefresh,
          ),
        );
  }

  SliverPersistentHeader _buildSliverMenu(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _CustomSliverAppBarDelegate(
        minHeight: 40,
        maxHeight: 40,
        child: ColoredBox(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Text(
            textAlign: TextAlign.center,
            StringConstants().totalRanking,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
      ),
    );
  }

  SliverAppBar _buildHeader(BuildContext context, UserSearchingState state) {
    return SliverAppBar(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      expandedHeight: 400,
      flexibleSpace: FlexibleSpaceBar(
        background: Center(
          child: Column(
            children: [
              20.ph,
              Text(
                StringConstants().thePodium,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              20.ph,
              Stack(
                children: [
                  Image.asset(
                    'assets/images/podium.png',
                    width: 300,
                    height: 300,
                  ),
                  Positioned(
                    top: 15,
                    left: 0,
                    right: 0,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: _FloatingChildWidget(
                        child: InkWell(
                          onTap: () => context.push(
                            '${RouteName.profilePage}/${state.users?.data[0].id}',
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                width: 70,
                                child: Text(
                                  textAlign: TextAlign.center,
                                  state.users!.data[0].username,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                              5.ph,
                              ProfilePicture(
                                uploadedFile: state.users?.data[0].avatar,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 120,
                    left: 30,
                    child: _FloatingChildWidget(
                      child: InkWell(
                        onTap: () => context.push(
                          '${RouteName.profilePage}/${state.users?.data[1].id}',
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              width: 70,
                              child: Text(
                                textAlign: TextAlign.center,
                                state.users!.data[1].username,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            ),
                            5.ph,
                            ProfilePicture(
                              uploadedFile: state.users?.data[1].avatar,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 140,
                    right: 30,
                    child: _FloatingChildWidget(
                      child: InkWell(
                        onTap: () => context.push(
                          '${RouteName.profilePage}/${state.users?.data[2].id}',
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              width: 70,
                              child: Text(
                                textAlign: TextAlign.center,
                                state.users!.data[2].username,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            ),
                            5.ph,
                            ProfilePicture(
                              uploadedFile: state.users?.data[2].avatar,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              20.ph,
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomSliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _CustomSliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_CustomSliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class _FloatingChildWidget extends HookWidget {
  const _FloatingChildWidget({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final AnimationController controller = useAnimationController(
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    final Animation<double> animation =
        Tween<double>(begin: -5.0, end: 5.0).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOut),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0.0, animation.value),
          child: child,
        );
      },
      child: child,
    );
  }
}
