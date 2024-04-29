import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/my_colors.dart';
import '../constants/route_name.dart';

class MyFriendsMyPostsMenu extends StatefulWidget {
  const MyFriendsMyPostsMenu({super.key});

  @override
  State<MyFriendsMyPostsMenu> createState() => _MyFriendsMyPostsMenuState();
}

class _MyFriendsMyPostsMenuState extends State<MyFriendsMyPostsMenu> {
  late String _selectedRoute;

  @override
  void initState() {
    super.initState();
    _selectedRoute =
        GoRouter.of(context).routeInformationProvider.value.uri.path;
  }

  void _updateSelectedRoute(String route) {
    setState(() {
      _selectedRoute = route;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            context.go(RouteName.myFriends);
            _updateSelectedRoute(RouteName.myFriends);
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.5,
            height: 30,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: _selectedRoute.contains(RouteName.myFriends)
                      ? MyColors.purple
                      : Colors.transparent,
                ),
              ),
            ),
            child: const Text(
              'Mes amis',
              textAlign: TextAlign.center,
              style: TextStyle(color: MyColors.purple),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            context.go(RouteName.myPosts);
            _updateSelectedRoute(RouteName.myPosts);
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.5,
            height: 30,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: _selectedRoute.contains(RouteName.myPosts)
                      ? MyColors.purple
                      : Colors.transparent,
                ),
              ),
            ),
            child: const Text(
              'Mes posts',
              textAlign: TextAlign.center,
              style: TextStyle(color: MyColors.purple),
            ),
          ),
        ),
      ],
    );
  }
}
