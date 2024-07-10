import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../api/quiz/quiz_service.dart';
import '../bloc/edit_quiz/edit_quiz_bloc.dart';
import '../constants/string_constants.dart';
import '../num_extensions.dart';
import '../repository/quiz/quiz_repository.dart';
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
      child: BlocBuilder<EditQuizBloc, EditQuizState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                20.ph,
                const Text(
                  'Edit Quiz',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                20.ph,
                if (state.status == EditQuizStatus.loading)
                  const Center(
                    child: CircularProgressIndicator(),
                  )
                else if (state.status == EditQuizStatus.error)
                  Center(
                    child: Text(state.error!.getDescription()),
                  )
                else
                  Column(
                    children: state.questions
                        .map(
                          (question) => Row(
                            children: [
                              Text(question.question),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  final bool result = await confirmationPopUp(
                                    context,
                                    title:
                                        StringConstants().sureToDeleteQuestion,
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
