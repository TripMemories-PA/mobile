import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/profile/profile_bloc.dart';
import '../constants/my_colors.dart';
import '../num_extensions.dart';

class FriendsAndVisitedWidget extends StatelessWidget {
  const FriendsAndVisitedWidget({super.key, this.itIsMe = false});

  final bool itIsMe;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (itIsMe) _buildFriendsCard(context),
                20.pw,
                _buildVisitedBuildingCard(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFriendsCard(BuildContext context) {
    int? friendsCount = context.read<ProfileBloc>().state.friends?.meta.total;
    friendsCount ??= 0;
    return _buildCard(
      context,
      friendsCount.toString(),
      'amis ajoutés',
      friendsCount,
    );
  }

  Widget _buildVisitedBuildingCard(BuildContext context) {
    const int visitedCount =
        0; //context.read<ProfileBloc>().state.visitedBuildings?.meta.total;
    //visitedCount ??= 0;
    return _buildCard(
      context,
      visitedCount.toString(),
      'monuments visités',
      visitedCount,
    );
  }

  Widget _buildCard(
    BuildContext context,
    String mainText,
    String subText,
    int? count,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            count?.toString() ?? '0',
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(subText),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              color: MyColors.darkGrey,
              height: 1,
              width: 140,
            ),
          ),
        ],
      ),
    );
  }
}
