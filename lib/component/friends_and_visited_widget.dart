import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/profile/profile_bloc.dart';
import '../constants/string_constants.dart';
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
                if (itIsMe)
                  state.status == ProfileStatus.loading
                      ? const SizedBox(
                          width: 30,
                          height: 30,
                          child: CupertinoActivityIndicator(),
                        )
                      : _buildFriendsCard(context),
                if (state.status == ProfileStatus.loading)
                  const SizedBox(
                    width: 30,
                    height: 30,
                    child: CupertinoActivityIndicator(),
                  )
                else
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
      context,
    );
  }

  Widget _buildVisitedBuildingCard(BuildContext context) {
    final int visitedCount =
        context.read<ProfileBloc>().state.profile?.poisCount ?? 0;
    return _buildCard(
      StringConstants().visitedBuildings,
      visitedCount,
      context,
    );
  }

  Widget _buildCard(
    String subText,
    int count,
    BuildContext context,
  ) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
        ),
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
            15.ph,
          ],
        ),
      ),
    );
  }
}
