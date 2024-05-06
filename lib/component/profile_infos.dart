import 'package:flutter/cupertino.dart';

import 'banner_picture.dart';
import 'profile_banner.dart';

class ProfileInfos extends StatelessWidget {
  const ProfileInfos({
    super.key,
    this.isMyProfile = false,
  });

  final bool isMyProfile;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
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
        ],
      ),
    );
  }
}
