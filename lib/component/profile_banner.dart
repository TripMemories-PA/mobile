import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/profile/profile_bloc.dart';
import '../num_extensions.dart';
import 'friends_and_visited_widget.dart';
import 'popup/modify_user_infos_popup.dart';

class ProfileBanner extends StatelessWidget {
  const ProfileBanner({
    super.key,
    this.isMyProfile = false,
  });

  final bool isMyProfile;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Column(
                children: [
                  10.ph,
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: IconButton(
                        onPressed: () async {
                          await modifyUserInfosPopup(context);
                        },
                        icon: const Icon(
                          Icons.edit,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    '${context.read<ProfileBloc>().state.profile?.firstname ?? 'User'} ${context.read<ProfileBloc>().state.profile?.lastname ?? context.read<ProfileBloc>().state.profile?.id.toString()}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '@${context.read<ProfileBloc>().state.profile?.username}',
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                  FriendsAndVisitedWidget(
                    itIsMe: isMyProfile,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
