import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../constants/my_colors.dart';
import '../../num_extensions.dart';
import '../custom_card.dart';

class UserInfosFormPopup extends StatelessWidget {
  const UserInfosFormPopup({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Dialog(
        insetPadding: EdgeInsets.zero,
        child: SizedBox(
          width: 370,
          height: MediaQuery.of(context).size.height * 0.8,
          child: CustomCard(
            content: _buildRankingContent(context),
          ),
        ),
      );

  Widget _buildRankingContent(BuildContext context) {
    return ListView(
      children: [
        SizedBox(
          height: 230,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              Form(
                child: Column(
                  children: [
                    Container(
                      height: 45,
                      decoration: ShapeDecoration(
                        color: MyColors.lightGrey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Nom d'utilisateur",
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                      ),
                    ),
                    15.ph,
                    Container(
                      height: 45,
                      decoration: ShapeDecoration(
                        color: MyColors.lightGrey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Nom',
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                      ),
                    ),
                    15.ph,
                    Container(
                      height: 45,
                      decoration: ShapeDecoration(
                        color: MyColors.lightGrey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Prénom',
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                      ),
                    ),
                    15.ph,
                    Container(
                      height: 45,
                      decoration: ShapeDecoration(
                        color: MyColors.lightGrey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.alternate_email),
                        ),
                      ),
                    ),
                    15.ph,
                    InkWell(
                      onTap: () async {
                        Navigator.of(context).pop(true);
                      },
                      child: Container(
                        height: 45,
                        decoration: ShapeDecoration(
                          color: MyColors.success,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            'Modifier les informations',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              15.ph,
              Form(
                child: Column(
                  children: [
                    Container(
                      height: 45,
                      decoration: ShapeDecoration(
                        color: MyColors.lightGrey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Mot de passe',
                          border: InputBorder.none,
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: InkWell(
                            child: const Icon(Icons.remove_red_eye_outlined),
                            onTap: () {},
                          ),
                        ),
                      ),
                    ),
                    15.ph,
                    Container(
                      height: 45,
                      decoration: ShapeDecoration(
                        color: MyColors.lightGrey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Confirmation de mot de passe',
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.lock_outline),
                        ),
                      ),
                    ),
                    15.ph,
                    InkWell(
                      onTap: () async {
                        Navigator.of(context).pop(true);
                      },
                      child: Container(
                        height: 45,
                        decoration: ShapeDecoration(
                          color: MyColors.success,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            'Modifier les informations',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
