import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';

import '../bloc/monument_bloc/monument_bloc.dart';
import '../constants/string_constants.dart';
import '../num_extensions.dart';
import 'searching_monuments_body.dart';

class SearchByMonument extends HookWidget {
  const SearchByMonument({super.key});

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
      child: Column(
        children: [
          const _SearchByMonumentHeader(),
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
}

class _SearchByMonumentHeader extends StatelessWidget {
  const _SearchByMonumentHeader();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: 180,
          child: Image.asset(
            'assets/images/panorama.jpg',
            fit: BoxFit.cover,
          ),
        ),
        Column(
          children: [
            30.ph,
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 50, left: 50, right: 50),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: '${StringConstants.discoverTheIncredible} ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: GoogleFonts.urbanist().fontFamily,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: StringConstants.monuments,
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          fontFamily: GoogleFonts.urbanist().fontFamily,
                        ),
                      ),
                      TextSpan(
                        text:
                            ' ${StringConstants.theTreasuresThatFranceHarbors}',
                        style: TextStyle(
                          fontFamily: GoogleFonts.urbanist().fontFamily,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
