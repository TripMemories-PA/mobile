import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../bloc/monument_bloc/monument_bloc.dart';
import '../../repository/monument/monument_repository.dart';
import '../bloc/city_bloc/city_bloc.dart';
import '../component/search_by_city.dart';
import '../component/search_by_monument.dart';
import '../constants/string_constants.dart';
import '../repository/city/cities_repository.dart';

class SearchPage extends HookWidget {
  const SearchPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MonumentBloc(
            monumentRepository:
                RepositoryProvider.of<MonumentRepository>(context),
          )..add(
              GetMonumentsEvent(
                isRefresh: true,
              ),
            ),
        ),
        BlocProvider(
          create: (context) => CityBloc(
            cityRepository: RepositoryProvider.of<CityRepository>(context),
          )..add(
              GetCitiesEvent(
                isRefresh: true,
              ),
            ),
        ),
      ],
      child: const SlidePage(),
    );
  }
}

class SlidePage extends HookWidget {
  const SlidePage({super.key});

  @override
  Widget build(BuildContext context) {
    final PageController pageController = usePageController();
    final citySearchSelected = useState(false);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _SearchPageAppBar(
        citySearchSelected: citySearchSelected,
        pageController: pageController,
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          citySearchSelected.value = index == 1;
        },
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: const SearchByMonument(),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: const SearchByCity(),
          ),
        ],
      ),
    );
  }
}

class _SearchPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _SearchPageAppBar({
    required this.citySearchSelected,
    required this.pageController,
  });

  final ValueNotifier<bool> citySearchSelected;
  final PageController pageController;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      title: Container(
        height: 30,
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: SearchPageToggleButtons(
          citySearchSelected: citySearchSelected,
          pageController: pageController,
        ),
      ),
      centerTitle: true,
    );
  }
}

class SearchPageToggleButtons extends StatelessWidget {
  const SearchPageToggleButtons({
    super.key,
    required this.citySearchSelected,
    required this.pageController,
  });

  final ValueNotifier<bool> citySearchSelected;
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      onPressed: (int index) {
        citySearchSelected.value = index == 1;
        pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      borderRadius: const BorderRadius.all(Radius.circular(15)),
      selectedColor: Theme.of(context).colorScheme.onPrimary,
      fillColor: Theme.of(context).colorScheme.primary,
      color: Theme.of(context).colorScheme.onSecondary,
      constraints: const BoxConstraints(
        minHeight: 30.0,
        minWidth: 170.0,
      ),
      isSelected: citySearchSelected.value ? [false, true] : [true, false],
      children: const <Widget>[
        Text(StringConstants.searchByName),
        Text(StringConstants.searchByCity),
      ],
    );
  }
}
