import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/profile/profile_bloc.dart';
import '../constants/my_colors.dart';
import '../constants/string_constants.dart';

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
                _buildVisitedBuildingCard(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFriendsCard(BuildContext context) {
    final int friendsCount =
        context.read<ProfileBloc>().state.friends.meta.total;
    return _buildCard(
      StringConstants().friendAdded,
      friendsCount,
    );
  }

  Widget _buildVisitedBuildingCard(BuildContext context) {
    final int visitedCount =
        context.read<ProfileBloc>().state.profile?.poisCount ?? 0;
    return _buildCard(
      StringConstants().visitedBuildings,
      visitedCount,
    );
  }

  Widget _buildCard(
    String subText,
    int count,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            count.toString(),
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
              width: 130,
            ),
          ),
        ],
      ),
    );
  }
}
