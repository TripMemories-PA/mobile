import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip_memories_mobile/component/popup/confirmation_logout_dialog.dart';
import 'package:trip_memories_mobile/component/profile_picture.dart';

import '../bloc/auth_bloc/auth_bloc.dart';
import '../bloc/auth_bloc/auth_event.dart';
import 'banner_picture.dart';
import 'bouncing_widget.dart';
import 'custom_card.dart';
import 'profile_banner.dart';

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
      height: 250,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          const BannerPicture(
            isMyProfile: true,
          ),
          Positioned(
            bottom: 0,
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
                  backgroundColor: Colors.white,
                  content: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Text(
                      'Se déconnecter',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  borderColor: Colors.transparent,
                ),
              ),
            ),
          Positioned(
            child: Center(
              child: ProfilePicture(
                isMyProfile: isMyProfile,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
