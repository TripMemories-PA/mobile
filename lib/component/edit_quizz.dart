import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../api/quiz/quiz_service.dart';
import '../bloc/edit_quiz/edit_quiz_bloc.dart';
import '../constants/route_name.dart';
import '../constants/string_constants.dart';
import '../num_extensions.dart';
import '../object/quiz/question.dart';
import '../page/edit_question_page.dart';
import '../repository/quiz/quiz_repository.dart';
import '../utils/messenger.dart';
import 'custom_card.dart';
import 'popup/confirmation_dialog.dart';

class EditQuiz extends StatelessWidget {
  const EditQuiz({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditQuizBloc(
        quizRepository: RepositoryProvider.of<QuizRepository>(
          context,
        ),
        quizService: QuizService(),
      )..add(
          GetMyQuizEvent(
            isRefresh: true,
          ),
        ),
      child: BlocConsumer<EditQuizBloc, EditQuizState>(
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
                      StringConstants().editQuiz,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () async {
                        context.push(
                          RouteName.editQuestion,
                          extra: EditQuestionDTO(
                            editQuizBloc: context.read<EditQuizBloc>(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add),
                    ),
                    10.ph,
                  ],
                ),
                20.ph,
                if (state.status == EditQuizStatus.loading)
                  const Center(
                    child: CircularProgressIndicator(),
                  )
                else
                  Column(
                    children: [
                      ...state.questions.map(
                        (question) => EditQuestionWidget(
                          question: question,
                        ),
                      ),
                      Builder(
                        builder: (context) {
                          switch (state.searchingMoreQuestionsStatus) {
                            case EditQuizStatus.loading:
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            case EditQuizStatus.error:
                              return Center(
                                child: Text(state.error!.getDescription()),
                              );
                            case EditQuizStatus.notLoading:
                              if (state.hasMoreQuestions) {
                                return ElevatedButton(
                                  onPressed: () =>
                                      context.read<EditQuizBloc>().add(
                                            GetMyQuizEvent(),
                                          ),
                                  child:
                                      Text(StringConstants().loadMoreResults),
                                );
                              } else {
                                return Text(StringConstants().noMoreQuestions);
                              }
                          }
                        },
                      ),
                    ],
                  ),
              ],
            ),
          );
        },
        listener: (BuildContext context, EditQuizState state) {
          switch (state.smallEvent) {
            case EditQuizSmallEvent.deleteQuestion:
              Messenger.showSnackBarSuccess(
                StringConstants().questionDeleted,
              );
            case null:
              break;

            case EditQuizSmallEvent.updateQuestion:
              Messenger.showSnackBarSuccess(
                StringConstants().questionUpdated,
              );
            case EditQuizSmallEvent.postQuestion:
              Messenger.showSnackBarSuccess(
                StringConstants().questionAdded,
              );
          }
          if (state.error != null) {
            Messenger.showSnackBarError(
              state.error!.getDescription(),
            );
          }
        },
      ),
    );
  }
}

class EditQuestionWidget extends StatelessWidget {
  const EditQuestionWidget({
    super.key,
    required this.question,
  });

  final Question question;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: CustomCard(
        onTap: () async {
          context.push(
            RouteName.editQuestion,
            extra: EditQuestionDTO(
              editQuizBloc: context.read<EditQuizBloc>(),
              question: question,
            ),
          );
        },
        height: 75,
        borderColor: Theme.of(context).colorScheme.tertiary,
        content: Row(
          children: [
            10.pw,
            Expanded(
              child: AutoSizeText(
                question.question,
                minFontSize: 5,
                maxLines: 2,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                final bool result = await confirmationPopUp(
                  context,
                  title: StringConstants().sureToDeleteQuestion,
                );
                if (!result) {
                  return;
                } else {
                  if (context.mounted) {
                    context.read<EditQuizBloc>().add(
                          DeleteQuestionEvent(
                            question.id,
                          ),
                        );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
