import 'package:image_picker/image_picker.dart';

import 'model/query/post_question_query.dart';
import 'model/response/check_question_response.dart';

abstract class IQuizService {
  Future<void> updateQuestion(int id);

  Future<void> deleteQuestion(int id);

  Future<void> postQuestion(PostQuestionQuery query);

  Future<CheckQuestionResponse> checkQuestionResponse({
    required int questionId,
    required int answerId,
  });

  Future<int> storeImage(XFile image);
}
