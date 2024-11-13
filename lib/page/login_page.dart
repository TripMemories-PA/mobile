import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../component/form/login_form.dart';
import '../component/form/subscribe_form.dart';
import '../component/no_indicator_scroll.dart';
import '../constants/string_constants.dart';
import '../num_extensions.dart';

class LoginPage extends HookWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TabController tabController = useTabController(initialLength: 2);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Column(
          children: [
            _buildHeader(),
            const SizedBox(
              height: 60,
              child: TabBar(
                dividerColor: Colors.transparent,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(
                    icon: Text(
                      StringConstants.login,
                      style: TextStyle(fontSize: 17),
                    ),
                    iconMargin: EdgeInsets.zero,
                  ),
                  Tab(
                    icon: Text(
                      StringConstants.subscribe,
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildLoginContent(context),
                  _buildSubscribeContent(context, tabController),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Stack _buildHeader() {
    return Stack(
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
    );
  }

  Widget _buildLoginContent(BuildContext context) {
    return NoIndicatorScroll(
      child: ListView(
        children: [
          Column(
            children: [
              40.ph,
              const Text(
                StringConstants.welcomeBack,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              15.ph,
              const Text(
                StringConstants.typeYourInfos,
                style: TextStyle(
                  fontSize: 16,
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

  Widget _buildSubscribeContent(
    BuildContext context,
    TabController tabController,
  ) {
    return NoIndicatorScroll(
      child: ListView(
        padding: const EdgeInsets.only(top: 20),
        children: [
          Column(
            children: [
              const Text(
                StringConstants.readyToComeAboard,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              15.ph,
              const Text(
                StringConstants.subscribeText,
                style: TextStyle(
                  fontSize: 13,
                ),
              ),
            ],
          ),
          15.ph,
          SubscribeForm(
            tabController: tabController,
          ),
        ],
      ),
    );
  }
}
