import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/string_constants.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({
    required this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: navigationShell,
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.search_outlined,
            ),
            label: StringConstants().search,
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.location_on_outlined,
            ),
            label: StringConstants().map,
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.notifications_outlined,
            ),
            label: StringConstants().feed,
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.shopping_cart_outlined,
            ),
            label: StringConstants().shop,
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.person_outline,
            ),
            label: StringConstants().profile,
          ),
        ],
        currentIndex: navigationShell.currentIndex,
        onTap: (int index) => _onTap(context, index),
      ),
    );
  }

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
