import 'package:flutter/material.dart';

import '../component/form/login_form.dart';
import '../component/no_indicator_scroll.dart';
import '../constants/my_colors.dart';
import '../num_extensions.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Column(
          children: [
            Stack(
              children: [
                Image.asset(
                  'assets/images/login_logo.jpg',
                  height: 180,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
                Center(
                  child: Image.asset(
                    'assets/images/tripmemories_white_logo.png',
                    width: 200,
                    height: 180,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 60,
              child: TabBar(
                tabs: [
                  Tab(icon: Text('Connexion'), iconMargin: EdgeInsets.zero),
                  Tab(icon: Text('Inscription')),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildContent(context),
                  const Center(
                    child: Text('This is the second tab'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return NoIndicatorScroll(
      child: ListView(
        children: [
          Column(
            children: [
              const Text(
                'Bon retour parmi nous ! 👋🏻',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              15.ph,
              const Text(
                'Continue avec Google ou entre tes infos',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              15.ph,
              Container(
                height: 60,
                width: MediaQuery.of(context).size.width * 0.60,
                decoration: ShapeDecoration(
                  color: MyColors.lightGrey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                child: Row(
                  children: [
                    15.pw,
                    const Icon(Icons.g_mobiledata_outlined),
                    15.pw,
                    const Text('Continuer avec Google'),
                  ],
                ),
              ),
            ],
          ),
          15.ph,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 3,
                width: MediaQuery.of(context).size.width * 0.40,
                decoration: const BoxDecoration(
                  color: MyColors.lightGrey,
                ),
              ),
              15.pw,
              const Text('ou'),
              15.pw,
              Container(
                height: 3,
                width: MediaQuery.of(context).size.width * 0.40,
                decoration: const BoxDecoration(
                  color: MyColors.lightGrey,
                ),
              ),
            ],
          ),
          15.ph,
          const LoginForm(),
        ],
      ),
    );
  }
}
