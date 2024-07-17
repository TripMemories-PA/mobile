import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../bloc/profile/profile_bloc.dart';
import '../../num_extensions.dart';
import '../../object/profile.dart';
import '../form/modify_password_form.dart';
import '../form/modify_user_infos_form.dart';
import '../profile_picture.dart';

class UserInfosFormPopup extends StatelessWidget {
  const UserInfosFormPopup({
    super.key,
    required this.profileBloc,
  });

  final ProfileBloc profileBloc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final Profile profile = profileBloc.state.profile!;
    final String? bannerUrl = profile.banner?.url;
    return SizedBox.expand(
      child: ListView(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.23,
            child: Stack(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 180,
                  child: ClipRRect(
                    child: bannerUrl != null
                        ? Image.network(
                            bannerUrl,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/images/louvre.png',
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: MediaQuery.of(context).size.width * 0.35,
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: ProfilePicture(
                      uploadedFile: profile.avatar,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => context.pop(false),
                    color: Colors.red,
                    iconSize: 30,
                  ),
                ),
              ],
            ),
          ),
          10.ph,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
            child: Column(
              children: [
                ModifyUserInfosForm(
                  profileBloc: profileBloc,
                ),
                30.ph,
                UpdatePasswordForm(profileBloc: profileBloc),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
