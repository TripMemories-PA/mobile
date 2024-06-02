import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc/auth_bloc.dart';
import '../bloc/auth_bloc/auth_event.dart';
import '../bloc/profile/profile_bloc.dart';
import '../constants/my_colors.dart';
import 'bouncing_widget.dart';
import 'custom_card.dart';
import 'popup/confirmation_logout_dialog.dart';
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
            color: Theme.of(context).colorScheme.background,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 65, child: Align(
                alignment: Alignment.centerLeft,
                child: BouncingWidget(
                  onTap: () async {
                    await modifyUserInfosPopup(context);
                  },
                  child: const CustomCard(
                    width: 100,
                    height: 25,
                    content: Text(
                      'Editer',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    borderColor: Colors.transparent,
                    backgroundColor: MyColors.purple,
                  ),
                ),
              ),),
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
            ],
          ),
        );
      },
    );
  }
}
