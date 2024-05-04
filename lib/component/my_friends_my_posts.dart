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
  int _currentPageIndex = 0;

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
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        PageView(
          controller: _pageViewController,
          onPageChanged: _handlePageViewChanged,
          children: const <Widget>[
            MyFriendsComponent(),
            MyPostsComponents(),
          ],
        ),
        PageIndicator(
          tabController: _tabController,
          currentPageIndex: _currentPageIndex,
          onUpdateCurrentPageIndex: _updateCurrentPageIndex,
        ),
      ],
    );
  }

  void _handlePageViewChanged(int currentPageIndex) {
    _tabController.index = currentPageIndex;
    setState(() {
      _currentPageIndex = currentPageIndex;
    });
  }

  void _updateCurrentPageIndex(int index) {
    _tabController.index = index;
    _pageViewController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }
}

class PageIndicator extends StatelessWidget {
  const PageIndicator({
    super.key,
    required this.tabController,
    required this.currentPageIndex,
    required this.onUpdateCurrentPageIndex,
  });

  final int currentPageIndex;
  final TabController tabController;
  final void Function(int) onUpdateCurrentPageIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        InkWell(
          onTap: () {
            onUpdateCurrentPageIndex(0);
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.5,
            height: 30,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: tabController.index == 0
                      ? Colors.purple
                      : Colors.transparent,
                ),
              ),
            ),
            child: const Text(
              'Mes amis',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.purple),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            onUpdateCurrentPageIndex(1);
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.5,
            height: 30,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: tabController.index == 1
                      ? Colors.purple
                      : Colors.transparent,
                ),
              ),
            ),
            child: const Text(
              'Mes posts',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.purple),
            ),
          ),
        ),
      ],
    );
  }
}
