import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../bloc/auth_bloc/auth_bloc.dart';
import '../bloc/auth_bloc/auth_state.dart';
import '../component/feed.dart';
import '../constants/route_name.dart';
import '../constants/string_constants.dart';

class FeedPage extends HookWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final PageController pageController = usePageController();
    final generalFeedSelected = useState(false);
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final int userTypeId = state.user?.userTypeId ?? 0;
        return SafeArea(
          child: Scaffold(
            floatingActionButton: context.read<AuthBloc>().state.status ==
                        AuthStatus.authenticated &&
                    userTypeId != 3
                ? FloatingActionButton(
                    onPressed: () => context.push(RouteName.editTweetPage),
                    child: const Icon(Icons.add),
                  )
                : null,
            appBar: context.read<AuthBloc>().state.status ==
                    AuthStatus.authenticated
                ? _buildAppBar(context, pageController, generalFeedSelected)
                : null,
            body: context.read<AuthBloc>().state.status == AuthStatus.authenticated
                ? _buildPageView(pageController, generalFeedSelected)
                : const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: FeedComponent(),
                  ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    PageController pageController,
    ValueNotifier<bool> generalFeedSelected,
  ) {
    return AppBar(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      title: Container(
        height: 30,
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: ToggleButtons(
          onPressed: (int index) {
            generalFeedSelected.value = index == 1;
            pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          selectedColor: Theme.of(context).colorScheme.onPrimary,
          fillColor: Theme.of(context).colorScheme.primary,
          color: Theme.of(context).colorScheme.onSecondary,
          constraints: const BoxConstraints(
            minHeight: 30.0,
            minWidth: 170.0,
          ),
          isSelected: generalFeedSelected.value ? [false, true] : [true, false],
          children: <Widget>[
            Text(StringConstants().myFeed),
            Text(StringConstants().generalFeed),
          ],
        ),
      ),
      centerTitle: true,
    );
  }

  PageView _buildPageView(PageController pageController, ValueNotifier<bool> generalFeedSelected) {
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        generalFeedSelected.value = index == 1;
      },
      children: const [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: FeedComponent(isMyFeed: true,),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: FeedComponent(),
        ),
      ],
    );
  }
}
