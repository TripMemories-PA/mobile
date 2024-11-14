import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/auth_bloc/auth_bloc.dart';
import '../bloc/auth_bloc/auth_state.dart';
import '../constants/string_constants.dart';

class ScaffoldWithNavBarPoi extends StatelessWidget {
  const ScaffoldWithNavBarPoi({
    required this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBarPoi'));

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: navigationShell,
          ),
          bottomNavigationBar: _buildPoiNavigationBar(context),
        );
      },
    );
  }

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  BottomNavigationBar _buildPoiNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      showUnselectedLabels: true,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Colors.grey,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            Icons.shopping_cart_outlined,
          ),
          label: StringConstants.shop,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.notifications_outlined,
          ),
          label: StringConstants.feed,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.qr_code_2,
          ),
          label: StringConstants.qrCodeScanner,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.person_outline,
          ),
          label: StringConstants.profile,
        ),
      ],
      currentIndex: navigationShell.currentIndex,
      onTap: (int index) => _onTap(context, index),
    );
  }
}
