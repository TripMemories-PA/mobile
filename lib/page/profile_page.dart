import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../component/custom_card.dart';
import '../component/my_friends_my_posts_menu.dart';
import '../component/profile_banner.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({
    required this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Column(
            children: [
              _buildProfileInfos(context),
              const SizedBox(
                height: 20,
              ),
              _buildSubsAndVisitedPlaces(context),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: Column(
              children: [
                const MyFriendsMyPostsMenu(),
                const SizedBox(
                  height: 15,
                ),
                navigationShell,
              ],
            ),
          ),
        ],
      ),
    );
  }

  SizedBox _buildProfileInfos(BuildContext context) {
    return SizedBox(
      height: 280,
      width: MediaQuery.of(context).size.width,
      child: Stack(children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          ),
          child: Image.asset('assets/images/louvre.png'),
        ),
        const Positioned(bottom: 0, child: ProfileBanner()),
      ]),
    );
  }

  Center _buildSubsAndVisitedPlaces(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomCard(
            width: MediaQuery.of(context).size.width * 0.45,
            heigth: 80,
            content: _buildFriendsCard(context),
          ),
          const SizedBox(
            width: 20,
          ),
          CustomCard(
            width: MediaQuery.of(context).size.width * 0.45,
            heigth: 80,
            content: _buildVisitedBuildingCard(context),
          ),
        ],
      ),
    );
  }

  Widget _buildFriendsCard(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text('NB ABONNES'), Text('amis ajoutés')],
      ),
    );
  }

  Widget _buildVisitedBuildingCard(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text('NB VISITED'), Text('monuments visités')],
      ),
    );
  }
}
