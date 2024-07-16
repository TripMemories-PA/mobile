import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../api/quest/quest_service.dart';
import '../bloc/quest/quest_bloc.dart';
import '../bloc/quest/quest_event.dart';
import '../constants/route_name.dart';
import '../constants/string_constants.dart';
import '../dto/quest_dto.dart';
import '../num_extensions.dart';
import '../repository/quest/quest_repository.dart';
import '../utils/messenger.dart';
import 'quest_card.dart';

class PoiQuestEditor extends StatelessWidget {
  const PoiQuestEditor({super.key, required this.poiId});

  final int poiId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuestBloc(
        questRepository: RepositoryProvider.of<QuestRepository>(context),
        questService: QuestService(),
      )..add(
          GetPoiQuestEvent(poiId, isRefresh: true),
        ),
      child: BlocConsumer<QuestBloc, QuestState>(
        listener: (context, state) {
          if (state.status == QuestStatus.error) {
            Messenger.showSnackBarError(
              state.error?.getDescription() ?? StringConstants().errorOccurred,
            );
          } else if (state.status == QuestStatus.deleted) {
            Messenger.showSnackBarSuccess(StringConstants().questDeleted);
          } else if (state.status == QuestStatus.updated) {
            Messenger.showSnackBarSuccess(StringConstants().questUpdated);
          }
        },
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<QuestBloc>().add(
                    GetPoiQuestEvent(poiId, isRefresh: true),
                  );
            },
            child: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      20.ph,
                      Row(
                        children: [
                          const Spacer(),
                          Text(
                            StringConstants().missions,
                            style: TextStyle(
                              fontSize: 30,
                              color: Theme.of(context).colorScheme.primary,
                              fontFamily: GoogleFonts.urbanist(
                                      fontWeight: FontWeight.w700)
                                  .fontFamily,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () async {
                              context.push(
                                RouteName.editQuest,
                                extra: QuestBlocDTO(
                                  questBloc: context.read<QuestBloc>(),
                                  poiId: poiId,
                                ),
                              );
                            },
                            icon: const Icon(Icons.add),
                          ),
                          10.ph,
                        ],
                      ),
                      20.ph,
                      if (state.status == QuestStatus.loading)
                        const Center(child: CircularProgressIndicator())
                      else
                        state.questList.isEmpty
                            ? Text(StringConstants().noQuestForThisMonument)
                            : Column(
                                children: [
                                  ...state.questList.map(
                                    (quest) => Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: QuestCard(
                                        quest: quest,
                                      ),
                                    ),
                                  ),
                                  if (state.hasMoreQuest)
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: state.moreQuestStatus ==
                                              QuestStatus.loading
                                          ? const CircularProgressIndicator()
                                          : ElevatedButton(
                                              onPressed: () {
                                                context.read<QuestBloc>().add(
                                                      GetPoiQuestEvent(poiId),
                                                    );
                                              },
                                              style: ButtonStyle(
                                                shape: WidgetStateProperty.all(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                  ),
                                                ),
                                                backgroundColor:
                                                    WidgetStateProperty.all(
                                                  Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                ),
                                              ),
                                              child: Text(
                                                StringConstants()
                                                    .loadMoreResults,
                                              ),
                                            ),
                                    )
                                  else
                                    Text(StringConstants().noMoreQuests),
                                ],
                              ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
