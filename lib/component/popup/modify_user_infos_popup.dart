import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../bloc/profile/profile_bloc.dart';
import '../../constants/my_colors.dart';
import '../../num_extensions.dart';
import '../../object/profile/profile.dart';
import '../custom_card.dart';
import '../form/modify_password_form.dart';
import '../form/modify_user_infos_form.dart';

class UserInfosFormPopup extends StatelessWidget {
  const UserInfosFormPopup({
    super.key,
    required this.profileBloc,
  });

  final ProfileBloc profileBloc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Builder(
        builder: (context) {
          return Dialog(
            insetPadding: EdgeInsets.zero,
            child: CustomCard(
              width: MediaQuery.of(context).size.width * 0.90,
              height: MediaQuery.of(context).size.height * 0.81,
              content: _buildContent(context),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final Profile profile = profileBloc.state.profile!;
    final String? avatarUrl = profile.avatar?.url;
    final String? bannerUrl = profile.banner?.url;
    return ListView(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.23,
          child: Stack(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 180,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14.0),
                  child: bannerUrl != null
                      ? Image.network(
                          bannerUrl,
                          fit: BoxFit.cover,
                        )
                      : Image.asset('assets/images/louvre.png'),
                ),
              ),
              Positioned(
                bottom: 0,
                left: MediaQuery.of(context).size.width * 0.35,
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(50.0),
                    ),
                    child: avatarUrl != null
                        ? Image.network(
                            avatarUrl,
                            fit: BoxFit.cover,
                          )
                        : const CircleAvatar(
                            backgroundColor: MyColors.lightGrey,
                            child: Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),
                  ),
                ),
              ),
              Positioned(
                right: 20,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => context.pop(false),
                  color: Colors.red,
                  iconSize: 40,
                ),
              ),
            ],
          ),
        ),
        10.ph,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              ModifyUserInfosForm(
                profileBloc: profileBloc,
              ),
              15.ph,
              const UpdatePasswordForm(),
            ],
          ),
        ),
      ],
    );
  }
}

Future<bool> modifyUserInfosPopup(
    BuildContext context,) async {
  return await showDialog<bool>(
    context: context,
    builder: (_) =>
       UserInfosFormPopup(
        profileBloc: context.read<ProfileBloc>(),
      ),

  ) ??
      false;
}
