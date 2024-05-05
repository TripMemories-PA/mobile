import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/profile/profile_bloc.dart';
import '../num_extensions.dart';
import 'custom_card.dart';

class FriendsAndVisitedWidget extends StatelessWidget {
  const FriendsAndVisitedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomCard(
            width: MediaQuery.of(context).size.width * 0.45,
            height: 50,
            content: _buildFriendsCard(context),
          ),
          20.pw,
          CustomCard(
            width: MediaQuery.of(context).size.width * 0.45,
            height: 50,
            content: _buildVisitedBuildingCard(context),
          ),
        ],
      ),
    );
  }

  Widget _buildFriendsCard(BuildContext context) {
    int? friendsCount = context.read<ProfileBloc>().state.friends?.meta.total;
    friendsCount ??= 0;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(friendsCount.toString()),
          const Text('amis ajoutés'),
        ],
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
