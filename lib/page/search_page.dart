import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../bloc/monument_bloc/monument_bloc.dart';
import '../../repository/monument/monument_repository.dart';
import '../../service/monument/monument_remote_data_source.dart';
import '../component/searching_monuments_body.dart';
import '../num_extensions.dart';

class SearchPage extends HookWidget {
  const SearchPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<MonumentRepository>(
      create: (context) => MonumentRepository(
        monumentRemoteDataSource: MonumentRemoteDataSource(),
        // TODO(nono): Implement ProfileLocalDataSource
        //profilelocalDataSource: ProfileLocalDataSource(),
      ),
      child: BlocProvider(
        create: (context) => MonumentBloc(
          monumentRepository:
              RepositoryProvider.of<MonumentRepository>(context),
        )..add(
            GetMonumentsEvent(
              isRefresh: true,
            ),
          ),
        child: const _Body(),
      ),
    );
  }
}

class _Body extends HookWidget {
  const _Body();

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
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          context.read<MonumentBloc>().add(
                GetMonumentsEvent(
                  isRefresh: true,
                  searchingCriteria: searchContent.value,
                ),
              );
        },
        child: Column(
          children: [
            _buildHeader(),
            20.ph,
            Expanded(
              child: SearchingMonumentBody(
                padding: 20,
                searchController: searchController,
                searchContent: searchContent,
                searching: searching,
                monumentsScrollController: monumentsScrollController,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _getMonuments(BuildContext context, String searchContent) {
    final monumentBloc = context.read<MonumentBloc>();

    if (monumentBloc.state.status != MonumentStatus.loading) {
      monumentBloc.add(
        GetMonumentsEvent(searchingCriteria: searchContent),
      );
    }
  }

  Widget _buildHeader() {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: 150,
          child: Image.asset(
            'assets/images/panorama.png',
            fit: BoxFit.cover,
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 50, left: 50, right: 50),
            child: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                text: 'Découvre les incroyables ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: 'monuments',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: ' dont recèle la France',
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
