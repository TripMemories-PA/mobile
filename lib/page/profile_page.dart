import 'package:flutter/material.dart';

import '../component/custom_card.dart';
import '../component/profile_banner.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
                child: Image.asset('assets/images/louvre.png'),
              ),
              const ProfileBanner(),
              const SizedBox(
                height: 20,
              ),
              Center(
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
              ),
            ],
          ),
          Container(
            color: Colors.yellow,
            child: const Center(
              child: Text(
                'Bloc jaune\n(pouvant dépasser en bas)',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
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
