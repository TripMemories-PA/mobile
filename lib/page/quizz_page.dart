import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../api/quiz/quiz_service.dart';
import '../bloc/quiz/quiz_bloc.dart';
import '../component/custom_card.dart';
import '../repository/quiz/quiz_repository.dart';

class QuizPage extends StatelessWidget {
  const QuizPage({super.key, this.monumentId});

  final int? monumentId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuizBloc(
        quizRepository: RepositoryProvider.of<QuizRepository>(
          context,
        ),
        quizService: QuizService(),
      )..add(
          GetQuizEvent(
            poiId: monumentId,
          ),
        ),
      child: BlocBuilder<QuizBloc, QuizState>(
        builder: (context, state) {
          return Scaffold(
            body: state.status == QuizStatus.loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : state.status == QuizStatus.error
                    ? Center(
                        child: Text(
                          state.error?.getDescription() ?? 'error',
                        ),
                      )
                    : Column(
              children: [
                CustomCard(content: Text(state.quiz?.data[state.currentQuestionIndex ?? 0].question ?? '')),
                ...?state.quiz?.data[state.currentQuestionIndex ?? 0].answers.map((answer) {
                  return CustomCard(content: Text(answer.answer ?? '',), onTap: () => context.read<QuizBloc>().add(CheckQuestionEvent(questionId: state.quiz?.data[state.currentQuestionIndex ?? 0], answerId: answerId)),);
                }),
              ],
            )
          );
        },
      ),
    );
  }
}
