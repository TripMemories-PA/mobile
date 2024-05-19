import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/profile/profile_bloc.dart';
import 'my_friends_component.dart';
import 'my_post_component.dart';

class MyFriendsMyPosts extends StatefulWidget {
  const MyFriendsMyPosts({super.key});

  @override
  State<MyFriendsMyPosts> createState() => _MyFriendsMyPostsState();
}

class _MyFriendsMyPostsState extends State<MyFriendsMyPosts>
    with TickerProviderStateMixin {
  late PageController _pageViewController;
  late TabController _tabController;
  late ScrollController _friendsScrollController;

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController();
    _tabController = TabController(length: 2, vsync: this);
    _friendsScrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageViewController.dispose();
    _tabController.dispose();
    _friendsScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _friendsScrollController.addListener(() {
      if (_friendsScrollController.position.atEdge) {
        if (_friendsScrollController.position.pixels != 0) {
          _getNextFriends(context);
        }
      }
    });
    return Column(
      children: <Widget>[
        TabBar(
          controller: _tabController,
          onTap: _updateCurrentPageIndex,
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: const [
            Tab(text: 'Mes amis'),
            Tab(text: 'Mes posts'),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 450,
          width: MediaQuery.of(context).size.width,
          child: PageView(
            controller: _pageViewController,
            onPageChanged: _handlePageViewChanged,
            children: <Widget>[
              SingleChildScrollView(
                controller: _friendsScrollController,
                child: const MyFriendsComponent(),
              ),
              const SingleChildScrollView(child: MyPostsComponents()),
            ],
          ),
        ),
      ],
    );
  }

  void _handlePageViewChanged(int currentPageIndex) {
    _tabController.animateTo(currentPageIndex);
  }

  void _updateCurrentPageIndex(int index) {
    _tabController.animateTo(index);
    _pageViewController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _getNextFriends(BuildContext context) {
    final tweetBloc = context.read<ProfileBloc>();

    if (tweetBloc.state.status != ProfileStatus.loading) {
      tweetBloc.add(
        GetFriendsEvent(),
      );
    }
  }
}
