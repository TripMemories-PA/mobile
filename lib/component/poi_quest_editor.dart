import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../api/quest/quest_service.dart';
import '../bloc/quest/quest_bloc.dart';
import '../bloc/quest/quest_event.dart';
import '../constants/string_constants.dart';
import '../num_extensions.dart';
import '../repository/quest/quest_repository.dart';
import '../utils/messenger.dart';
import 'popup/confirmation_dialog.dart';

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
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                20.ph,
                Row(
                  children: [
                    const Spacer(),
                    Text(
                      StringConstants().myMissions,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () async {},
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
                          children: state.questList
                              .map(
                                (quest) => ListTile(
                                  title: Text(quest.title),
                                  subtitle: Text(quest.title),
                                  trailing: IconButton(
                                    onPressed: () {
                                      confirmationPopUp(
                                        context,
                                        title: StringConstants()
                                            .sureToDeleteMission,
                                      ).then(
                                        (value) => value
                                            ? context.read<QuestBloc>().add(
                                                  DeleteQuestEvent(quest.id),
                                                )
                                            : null,
                                      );
                                    },
                                    icon: const Icon(CupertinoIcons.delete),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
              ],
            ),
          );
        },
      ),
    );
  }
}
