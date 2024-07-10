import 'package:flutter/cupertino.dart';

import '../bloc/edit_quiz/edit_quiz_bloc.dart';
import '../component/form/edit_question_form.dart';
import '../object/quiz/question.dart';

class EditQuestionPage extends StatelessWidget {
  const EditQuestionPage({
    super.key,
    required this.editQuestionDTO,
  });

  final EditQuestionDTO editQuestionDTO;

  @override
  Widget build(BuildContext context) {
    return EditQuestionForm(
      editQuestionDTO.question,
      editQuizBloc: editQuestionDTO.editQuizBloc,
    );
  }
}

class EditQuestionDTO {
  EditQuestionDTO({
    this.question,
    required this.editQuizBloc,
  });

  Question? question;
  EditQuizBloc editQuizBloc;
}
