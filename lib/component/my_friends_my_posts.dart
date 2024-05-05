import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _pageViewController.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            children: const <Widget>[
              SingleChildScrollView(child: MyFriendsComponent()),
              SingleChildScrollView(child: MyPostsComponents()),
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
}
