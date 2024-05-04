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
import 'profile_picture.dart';

class ProfileBanner extends StatelessWidget {
  const ProfileBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const ProfilePicture(),
              Column(
                children: [
                  const SizedBox(height: 30, width: 25),
                  Row(
                    children: [
                      Column(
                        children: [
                          Text(
                            '${context.read<ProfileBloc>().state.profile?.firstname ?? 'User'} ${context.read<ProfileBloc>().state.profile?.lastname ?? context.read<ProfileBloc>().state.profile?.id.toString()}',
                            style: const TextStyle(
                              fontSize: 15,
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
                      const SizedBox(width: 10),
                      BouncingWidget(
                        onTap: () async {
                          final bool result = await confirmationLogout(
                            context,
                            title:
                                'Etes-vous sûr de vouloir vous déconnecter ?',
                          );
                          if (!result) {
                            return;
                          } else {
                            if (context.mounted) {
                              context.read<AuthBloc>().add(
                                    const ChangeToLoggedOutStatus(),
                                  );
                            }
                          }
                        },
                        child: const CustomCard(
                          width: 50,
                          height: 25,
                          backgroundColor: Colors.red,
                          content: Icon(
                            Icons.logout,
                            color: Colors.white,
                            size: 15,
                          ),
                          borderColor: Colors.transparent,
                        ),
                      ),
                      const SizedBox(width: 10),
                      BouncingWidget(
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
                    ],
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
