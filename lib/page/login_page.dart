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
            SizedBox(
              height: 60,
              child: TabBar(
                tabs: [
                  Tab(
                    icon: Text(StringConstants().login),
                    iconMargin: EdgeInsets.zero,
                  ),
                  Tab(icon: Text(StringConstants().subscribe)),
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
              20.ph,
              Text(
                StringConstants().welcomeBack,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              15.ph,
              Text(
                StringConstants().typeYourInfos,
                style: const TextStyle(
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
              Text(
                StringConstants().readyToComeAboard,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              15.ph,
              Text(
                StringConstants().subscribeText,
                style: const TextStyle(
                  fontSize: 16,
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
