import 'package:audioplayers/audioplayers.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lottie/lottie.dart';
import 'package:vibration/vibration.dart';

import '../api/quiz/quiz_service.dart';
import '../bloc/quiz/quiz_bloc.dart';
import '../component/bouncing_widget.dart';
import '../component/custom_card.dart';
import '../constants/my_colors.dart';
import '../constants/string_constants.dart';
import '../num_extensions.dart';
import '../object/quiz/question.dart';
import '../object/quiz/quiz.dart';
import '../repository/quiz/quiz_repository.dart';
import '../utils/messenger.dart';

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
          final Quiz? quiz = state.quiz;
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.primary,
            body: state.status == QuizStatus.loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Center(
                    child: state.status == QuizStatus.error
                        ? Text(
                            state.error?.getDescription() ??
                                StringConstants().errorOccurred,
                          )
                        : (quiz != null
                            ? _buildBody(quiz, context)
                            : Center(
                                child: Text(StringConstants().noData),
                              )),
                  ),
          );
        },
      ),
    );
  }

  Column _buildBody(Quiz quiz, BuildContext context) {
    switch (context.read<QuizBloc>().state.quizGameStatus) {
      case QuizGameStatus.inProgress:
        return _buildQuiz(quiz, context);
      case QuizGameStatus.ended:
        return _buildEnd(quiz, context);
    }
  }

  Column _buildQuiz(Quiz quiz, BuildContext context) {
    final int totalQuestions = quiz.data.length;
    final double progress =
        (context.read<QuizBloc>().state.currentQuestionIndex + 1) /
            totalQuestions;

    return Column(
      children: [
        20.ph,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Row(
            children: [
              Text(
                '${context.read<QuizBloc>().state.currentQuestionIndex + 1} ${StringConstants().on} $totalQuestions',
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              const Spacer(),
              Text(
                '${context.read<QuizBloc>().state.score} ${StringConstants().points}',
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10),
          child: Stack(
            children: [
              Container(
                height: 5,
                width: MediaQuery.of(context).size.width - 80,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 5,
                  width: (MediaQuery.of(context).size.width - 80) * progress,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        QuestionWidget(
          question:
              quiz.data[context.read<QuizBloc>().state.currentQuestionIndex],
        ),
        const Spacer(),
      ],
    );
  }

  Column _buildEnd(Quiz quiz, BuildContext context) {
    final player = AudioPlayer();
    context.read<QuizBloc>().state.score < 40
        ? player.play(
            AssetSource(
              'sounds/mario_fail.mp3',
            ),
          )
        : player.play(
            AssetSource(
              'sounds/wow.mp3',
            ),
          );
    return Column(
      children: [
        const Spacer(),
        Text(
          StringConstants().quizEnded,
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
            fontSize: 25,
          ),
        ),
        20.ph,
        Lottie.asset(
          'assets/lottie/end_flag.json',
          width: 200,
          height: 200,
          fit: BoxFit.fill,
        ),
        20.ph,
        Text(
          '${StringConstants().score} : ${context.read<QuizBloc>().state.score}',
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
            fontSize: 25,
          ),
        ),
        20.ph,
        CustomCard(
          height: 50,
          width: 200,
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          borderColor: Colors.transparent,
          content: Text(
            StringConstants().back,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        const Spacer(),
      ],
    );
  }
}

class QuestionWidget extends HookWidget {
  const QuestionWidget({
    super.key,
    required this.question,
  });

  final Question question;

  @override
  Widget build(BuildContext context) {
    final answerSelected = useState(-1);
    final selectedColor =
        useState(Theme.of(context).colorScheme.primaryContainer);

    return BlocListener<QuizBloc, QuizState>(
      listener: (context, state) async {
        if (state.status == QuizStatus.error) {
          Messenger.showSnackBarError(
            state.error?.getDescription() ?? StringConstants().errorOccurred,
          );
        }
        if (state.isValidAnswer != null) {
          if (state.isValidAnswer!) {
            selectedColor.value = MyColors.success;
            final player = AudioPlayer();
            await player.play(
              AssetSource(
                'sounds/rizz-sounds.mp3',
              ),
            );
            Vibration.vibrate(amplitude: 128);
          } else {
            selectedColor.value = MyColors.fail;
            final player = AudioPlayer();
            await player.play(
              AssetSource(
                'sounds/windowError.mp3',
              ),
            );
            Vibration.vibrate(pattern: [0, 100, 500, 100], amplitude: 128);
          }
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        width: MediaQuery.of(context).size.width * 0.8,
        child: _buildContent(context, answerSelected, selectedColor),
      ),
    );
  }

  Padding _buildContent(
    BuildContext context,
    ValueNotifier<int> answerSelected,
    ValueNotifier<Color> selectedColor,
  ) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              StringConstants().selectAnAnswer,
              style: TextStyle(
                color: Theme.of(context).colorScheme.tertiary,
                fontSize: 15,
              ),
            ),
          ),
          10.ph,
          Align(
            alignment: Alignment.centerLeft,
            child: AutoSizeText(
              maxLines: 3,
              minFontSize: 15,
              question.question,
              style: const TextStyle(fontSize: 25),
            ),
          ),
          20.ph,
          if (question.image == null)
            _buildVerticalAnswers(answerSelected, context, selectedColor)
          else
            _buildVerticalAnswers(answerSelected, context, selectedColor),
          20.ph,
          Row(
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    StringConstants().back,
                  ),
                ),
              ),
              10.pw,
              Expanded(
                child: BouncingWidget(
                  onTap: () {
                    if (answerSelected.value == -1) {
                      Messenger.showSnackBarError(
                        StringConstants().selectAnAnswer,
                      );
                      return;
                    }
                    if (context.read<QuizBloc>().state.isValidAnswer != null) {
                      answerSelected.value = -1;
                      selectedColor.value =
                          Theme.of(context).colorScheme.primaryContainer;
                      context.read<QuizBloc>().add(GetNextQuestionEvent());
                    } else {
                      context.read<QuizBloc>().add(
                            CheckQuestionEvent(
                              questionId: question.id,
                              answerId: answerSelected.value,
                            ),
                          );
                    }
                  },
                  child: CustomCard(
                    height: 50,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    borderColor: Colors.transparent,
                    content: Text(
                      context.read<QuizBloc>().state.isValidAnswer != null
                          ? StringConstants().nextQuestion
                          : StringConstants().validate,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalAnswers(
    ValueNotifier<int> answerSelected,
    BuildContext context,
    ValueNotifier<Color> selectedColor,
  ) {
    return Column(
      children: question.answers.map((answer) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: CustomCard(
            onTap: () {
              if (context.read<QuizBloc>().state.isValidAnswer == null) {
                answerSelected.value = answer.id;
              }
            },
            backgroundColor: answerSelected.value == answer.id
                ? selectedColor.value
                : Theme.of(context).colorScheme.surface,
            borderColor: answerSelected.value == answer.id
                ? Colors.transparent
                : Theme.of(context).colorScheme.tertiary,
            borderRadius: 10,
            height: 70,
            content: Row(
              children: [
                10.pw,
                Checkbox(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  value: answerSelected.value == answer.id,
                  onChanged: (value) {
                    if (context.read<QuizBloc>().state.isValidAnswer == null) {
                      answerSelected.value = answer.id;
                    }
                  },
                  activeColor: Theme.of(context).colorScheme.primary,
                  checkColor: Colors.white,
                  side: WidgetStateBorderSide.resolveWith(
                    (Set<WidgetState> states) {
                      if (states.contains(WidgetState.selected)) {
                        return null;
                      }
                      return BorderSide(
                        color: Theme.of(context).colorScheme.tertiary,
                      );
                    },
                  ),
                ),
                10.pw,
                Expanded(
                  child: AutoSizeText(
                    answer.answer,
                    maxLines: 2,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
