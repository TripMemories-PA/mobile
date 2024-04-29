import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../num_extensions.dart';
import '../custom_card.dart';
import '../form/modify_password_form.dart';
import '../form/modify_user_infos_form.dart';

class UserInfosFormPopup extends StatelessWidget {
  const UserInfosFormPopup({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      child: CustomCard(
        width: MediaQuery.of(context).size.width * 0.90,
        height: MediaQuery.of(context).size.height * 0.81,
        content: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return ListView(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.26,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(15.0),
                ),
                child: Image.asset('assets/images/louvre.png'),
              ),
              Positioned(
                bottom: 0,
                left: MediaQuery.of(context).size.width * 0.35,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.20,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(50.0),
                    ),
                    child: Image.asset('assets/images/profileSample.png'),
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
              const ModifyUserInfosForm(),
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
  BuildContext context, {
  Color? color,
}) async {
  return (await showDialog<bool>(
        context: context,
        builder: (_) => const UserInfosFormPopup(),
      )) ??
      false;
}
