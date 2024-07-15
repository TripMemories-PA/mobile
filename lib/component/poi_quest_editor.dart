import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../api/quest/quest_service.dart';
import '../bloc/auth_bloc/auth_bloc.dart';
import '../bloc/quest/quest_bloc.dart';
import '../bloc/quest/quest_event.dart';
import '../constants/my_colors.dart';
import '../constants/route_name.dart';
import '../constants/string_constants.dart';
import '../dto/quest_dto.dart';
import '../num_extensions.dart';
import '../object/quest.dart';
import '../repository/quest/quest_repository.dart';
import '../utils/messenger.dart';
import 'custom_card.dart';

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
          return Center(
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
                          fontFamily:
                              GoogleFonts.urbanist(fontWeight: FontWeight.w700)
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
                                  child: MissionCard(
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
                                                    BorderRadius.circular(20.0),
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
                                            StringConstants().loadMoreResults,
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
          );
        },
      ),
    );
  }
}

class MissionCard extends StatelessWidget {
  const MissionCard({
    super.key,
    required this.quest,
  });

  final Quest quest;

  @override
  Widget build(BuildContext context) {
    final bool isAdmin =
        context.read<AuthBloc>().state.user?.poiId == quest.poiId;
    return CustomCard(
      height: 220,
      width: double.infinity,
      borderColor: Theme.of(context).colorScheme.tertiary,
      content: Row(
        children: [
          SizedBox(
            height: 220,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(10.0),
                ),
                child: Image.asset('assets/images/mission_photo.png'),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.sports_esports_outlined,
                        color: Theme.of(context).colorScheme.primary,
                        size: 25,
                      ),
                      const Spacer(),
                      Expanded(
                        child: CustomCard(
                          backgroundColor: Colors.transparent,
                          borderColor: Theme.of(context).colorScheme.primary,
                          content: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.redeem,
                                  size: 20,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                Text(
                                  '50 points',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.normal,
                                    fontFamily:
                                        GoogleFonts.urbanist().fontFamily,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  AutoSizeText(
                    quest.title,
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: GoogleFonts.urbanist().fontFamily,
                    ),
                    maxLines: 2,
                  ),
                  if (!isAdmin) const Spacer(),
                  if (!isAdmin)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          quest.done
                              ? StringConstants().done
                              : StringConstants().notDone,
                          style: TextStyle(
                            fontSize: 15,
                            color:
                                quest.done ? MyColors.success : MyColors.fail,
                            fontFamily: GoogleFonts.urbanist().fontFamily,
                          ),
                        ),
                        Center(
                          child: Icon(
                            quest.done ? Icons.check : Icons.close,
                            color:
                                quest.done ? MyColors.success : MyColors.fail,
                          ),
                        ),
                      ],
                    ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (quest.done && !isAdmin) {
                          return;
                        } else {
                          if (isAdmin) {
                            context.push(
                              RouteName.editQuest,
                              extra: QuestBlocDTO(
                                questBloc: context.read<QuestBloc>(),
                                quest: quest,
                                poiId: quest.poiId,
                              ),
                            );
                          } else {
                            //TODO: push vers la page de jeu
                          }
                        }
                      },
                      style: ButtonStyle(
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        backgroundColor: WidgetStateProperty.all(
                          isAdmin
                              ? Theme.of(context).colorScheme.primary
                              : (quest.done
                                  ? Theme.of(context).colorScheme.tertiary
                                  : Theme.of(context).colorScheme.primary),
                        ),
                      ),
                      child: Text(
                        isAdmin
                            ? StringConstants().edit
                            : StringConstants().play,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
