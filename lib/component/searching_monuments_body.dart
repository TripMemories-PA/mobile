import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../bloc/monument_bloc/monument_bloc.dart';
import '../constants/my_colors.dart';
import '../constants/string_constants.dart';
import '../num_extensions.dart';
import 'monument_resume_list.dart';
import 'search_bar_custom.dart';

class SearchingMonumentBody extends HookWidget {
  const SearchingMonumentBody({super.key, this.needToPop = false});

  final bool needToPop;

  void _getMonuments(BuildContext context, String searchContent) {
    final monumentBloc = context.read<MonumentBloc>();

    if (monumentBloc.state.status != MonumentStatus.loading) {
      monumentBloc.add(
        GetMonumentsEvent(searchingCriteria: searchContent),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = useTextEditingController();
    final searching = useState(false);
    final searchContent = useState('');
    final ScrollController monumentsScrollController = useScrollController();
    useEffect(
      () {
        void createScrollListener() {
          if (monumentsScrollController.position.atEdge) {
            if (monumentsScrollController.position.pixels != 0) {
              _getMonuments(context, searchContent.value);
            }
          }
        }

        monumentsScrollController.addListener(createScrollListener);
        return () =>
            monumentsScrollController.removeListener(createScrollListener);
      },
      const [],
    );
    return RefreshIndicator(
      onRefresh: () async {
        context.read<MonumentBloc>().add(
              GetMonumentsEvent(
                isRefresh: true,
                searchingCriteria: searchContent.value,
              ),
            );
      },
      child: SingleChildScrollView(
        controller: monumentsScrollController,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              _buildTitle(
                context,
                searching,
                searchController,
                searchContent,
              ),
              SearchBarCustom(
                searchController: searchController,
                context: context,
                searching: searching,
                searchContent: searchContent,
                hintText: 'Rechercher des monuments',
                onSearch: (value) {
                  context.read<MonumentBloc>().add(
                        GetMonumentsEvent(
                          searchingCriteria: value,
                          isRefresh: true,
                        ),
                      );
                },
              ),
              10.ph,
              _buildSearchMonumentList(searchContent),
            ],
          ),
        ),
      ),
    );
  }

  BlocBuilder<MonumentBloc, MonumentState> _buildSearchMonumentList(
    ValueNotifier<String> searchContent,
  ) {
    return BlocBuilder<MonumentBloc, MonumentState>(
      builder: (context, state) {
        if (state.status == MonumentStatus.error) {
          return _buildErrorWidget(context);
        } else if (state.status == MonumentStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.monuments.isEmpty) {
          return const Text('Aucun monument trouvé');
        } else {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${state.monuments.length} résultat${state.monuments.length > 1 ? 's' : ''}',
                    style: const TextStyle(
                      color: MyColors.darkGrey,
                    ),
                  ),
                ),
              ),
              MonumentResumeList(
                monuments: state.monuments,
                needToPop: needToPop,
              ),
              Center(
                child: state.searchMonumentsHasMoreMonuments
                    ? (state.status != MonumentStatus.error
                        ? const Text(
                            'SHIMMER HERE',
                          ) // TODO(nono): Add Shimmer effect here
                        : _buildErrorWidget(context))
                    : Text(StringConstants().noMoreMonuments),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildTitle(
    BuildContext context,
    ValueNotifier<bool> searching,
    TextEditingController searchController,
    ValueNotifier<String> searchContent,
  ) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 10.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Rechercher des monuments',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context) {
    return Column(
      children: [
        Text(StringConstants().errorAppendedWhileGettingData),
        ElevatedButton(
          onPressed: () => _getMonumentsRequest(context),
          child: Text(StringConstants().retry),
        ),
      ],
    );
  }

  void _getMonumentsRequest(BuildContext context) {
    context.read<MonumentBloc>().add(
          GetMonumentsEvent(),
        );
  }
}
