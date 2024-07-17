import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../bloc/auth_bloc/auth_bloc.dart';
import '../bloc/auth_bloc/auth_event.dart';
import '../constants/my_colors.dart';
import '../constants/string_constants.dart';
import 'banner_picture.dart';
import 'popup/confirmation_dialog.dart';
import 'profile_banner.dart';
import 'profile_picture.dart';

class ProfileInfos extends StatelessWidget {
  const ProfileInfos({
    super.key,
    this.isMyProfile = false,
  });

  final bool isMyProfile;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          const BannerPicture(
            isMyProfile: true,
          ),
          Positioned(
            top: 130,
            child: ProfileBanner(
              isMyProfile: isMyProfile,
            ),
          ),
          if (isMyProfile)
            Positioned(
              top: 10,
              right: 10,
              child: SpeedDial(
                buttonSize: const Size(50.0, 50.0),
                icon: Icons.menu,
                animatedIcon: AnimatedIcons.menu_close,
                animatedIconTheme: const IconThemeData(size: 22.0),
                direction: SpeedDialDirection.down,
                curve: Curves.bounceIn,
                overlayColor: Colors.black,
                overlayOpacity: 0.5,
                foregroundColor: Colors.white,
                elevation: 8.0,
                shape: const CircleBorder(),
                children: [
                  SpeedDialChild(
                    child: Icon(
                      Icons.logout,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    backgroundColor: MyColors.fail,
                    label: StringConstants().logout,
                    labelStyle: const TextStyle(fontSize: 18.0),
                    onTap: () async {
                      final bool result = await confirmationPopUp(
                        context,
                        title: StringConstants().logoutConfirmation,
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
                  ),
                  SpeedDialChild(
                    child: Icon(
                      Icons.delete,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    backgroundColor: MyColors.fail,
                    label: StringConstants().deleteAccount,
                    labelStyle: const TextStyle(
                      fontSize: 18.0,
                    ),
                    onTap: () {
                      confirmationPopUp(
                        context,
                        title: StringConstants().sureToDeleteAccount,
                      ).then((bool result) {
                        if (result && context.mounted) {
                          context.read<AuthBloc>().add(
                                DeleteAccountEvent(),
                              );
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
          Positioned(
            top: 70,
            left: MediaQuery.of(context).size.width / 2 - 50,
            child: ProfilePictureInteractive(
              isMyProfile: isMyProfile,
            ),
          ),
        ],
      ),
    );
  }
}
