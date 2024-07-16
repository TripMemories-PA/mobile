import '../bloc/edit_quiz/edit_quiz_bloc.dart';
import '../object/quiz/question.dart';

class EditQuestionDTO {
  EditQuestionDTO({
    this.question,
    required this.editQuizBloc,
  });

  Question? question;
  EditQuizBloc editQuizBloc;
}
