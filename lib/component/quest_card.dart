import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../bloc/auth_bloc/auth_bloc.dart';
import '../bloc/auth_bloc/auth_state.dart';
import '../bloc/quest/quest_bloc.dart';
import '../bloc/quest/quest_event.dart';
import '../constants/my_colors.dart';
import '../constants/route_name.dart';
import '../constants/string_constants.dart';
import '../dto/quest_dto.dart';
import '../object/quest.dart';
import 'custom_card.dart';
import 'popup/confirmation_dialog.dart';

class QuestCard extends StatelessWidget {
  const QuestCard({
    super.key,
    required this.quest,
  });

  final Quest quest;

  @override
  Widget build(BuildContext context) {
    final bool isAdmin =
        context.read<AuthBloc>().state.user?.poiId == quest.poiId &&
            context.read<AuthBloc>().state.status == AuthStatus.authenticated;
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
                      if (isAdmin)
                        IconButton(
                          onPressed: () {
                            confirmationPopUp(
                              context,
                              title: StringConstants.sureToDeleteQuest,
                            ).then(
                              (value) => (value && context.mounted)
                                  ? context
                                      .read<QuestBloc>()
                                      .add(DeleteQuestEvent(quest.id))
                                  : null,
                            );
                          },
                          icon: const Icon(Icons.delete),
                        )
                      else
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
                                    color:
                                        Theme.of(context).colorScheme.primary,
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
                              ? StringConstants.done
                              : StringConstants.notDone,
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
                        if (context.read<AuthBloc>().state.status !=
                            AuthStatus.authenticated) {
                          confirmationPopUp(
                            context,
                            title: StringConstants.pleaseLogin,
                            isOkPopUp: true,
                          );
                          return;
                        }
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
                            final QuestBlocDTO dto = QuestBlocDTO(
                              questBloc: context.read<QuestBloc>(),
                              quest: quest,
                              poiId: quest.poiId,
                            );
                            context.push(
                              RouteName.questDetails,
                              extra: dto,
                            );
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
                              : ((quest.done ||
                                      context.read<AuthBloc>().state.status !=
                                          AuthStatus.authenticated)
                                  ? Theme.of(context).colorScheme.tertiary
                                  : Theme.of(context).colorScheme.primary),
                        ),
                      ),
                      child: Text(
                        isAdmin
                            ? StringConstants.edit
                            : StringConstants.play,
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
