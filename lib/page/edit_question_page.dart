import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../component/form/edit_question_form.dart';
import '../dto/edit_question_dto.dart';
import '../num_extensions.dart';

class EditQuestionPage extends StatelessWidget {
  const EditQuestionPage({
    super.key,
    required this.editQuestionDTO,
  });

  final EditQuestionDTO editQuestionDTO;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox.shrink(),
        actions: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.close),
          ),
          10.pw,
        ],
      ),
      body: EditQuestionForm(
        editQuestionDTO.question,
        editQuizBloc: editQuestionDTO.editQuizBloc,
      ),
    );
  }
}
