import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc/auth_bloc.dart';
import '../bloc/auth_bloc/auth_event.dart';
import '../constants/string_constants.dart';
import 'banner_picture.dart';
import 'bouncing_widget.dart';
import 'custom_card.dart';
import 'popup/confirmation_logout_dialog.dart';
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
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
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
              child: BouncingWidget(
                onTap: () async {
                  final bool result = await confirmationPopUp(
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
                child: CustomCard(
                  backgroundColor: Colors.white,
                  content: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Text(
                      StringConstants().logout,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  borderColor: Colors.transparent,
                ),
              ),
            ),
          if (isMyProfile)
            Positioned(
              top: 10,
              left: 60,
              child: BouncingWidget(
                onTap: () {
                  confirmationPopUp(
                    context,
                    title: StringConstants().sureToDeleteAccount,
                  ).then((bool result) {
                    if (result) {
                      context.read<AuthBloc>().add(
                            DeleteAccountEvent(),
                          );
                    }
                  });
                },
                child: CustomCard(
                  backgroundColor: Colors.red,
                  width: 170,
                  height: 33,
                  content: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Text(
                      StringConstants().deleteAccount,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.surface),
                    ),
                  ),
                  borderColor: Colors.transparent,
                ),
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
