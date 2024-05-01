import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip_memories_mobile/component/popup/confirmation_logout_dialog.dart';

import '../bloc/auth_bloc/auth_bloc.dart';
import '../bloc/auth_bloc/auth_event.dart';
import '../bloc/profile/profile_bloc.dart';
import '../constants/my_colors.dart';
import '../object/profile/profile.dart';
import 'custom_card.dart';
import 'popup/modify_user_infos_popup.dart';

class ProfileBanner extends StatelessWidget {
  const ProfileBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final Profile? currentStateProfile =
        context.read<ProfileBloc>().state.profile;
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(50.0),
                ),
                child: currentStateProfile?.avatar?.url != null
                    ? Image.network(
                        currentStateProfile!.avatar!.url,
                        fit: BoxFit.cover,
                      )
                    : const CircleAvatar(
                        backgroundColor: MyColors.lightGrey,
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.grey,
                        ),
                      )),
          ),
          Column(
            children: [
              const SizedBox(height: 30, width: 25),
              Row(
                children: [
                  Column(
                    children: [
                      Text(
                        '${currentStateProfile?.firstname ?? 'User'} ${currentStateProfile?.lastname ?? currentStateProfile?.id.toString()}',
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '@${currentStateProfile?.username}',
                        style:
                            const TextStyle(fontSize: 15, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  InkWell(
                    onTap: () async {
                      final bool result = await confirmationLogout(
                        context,
                        title: 'Etes-vous sûr de vouloir vous déconnecter ?',
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
                  InkWell(
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
  }
}
