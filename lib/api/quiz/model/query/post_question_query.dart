import 'package:image_picker/image_picker.dart';

class PostQuestionQueryDto {
  PostQuestionQueryDto({
    required this.question,
    this.image,
    required this.answers,
  });

  String question;
  XFile? image;
  List<PostQuestionQueryAnswer> answers;
}

class PostQuestionQuery {
  PostQuestionQuery({
    required this.question,
    this.imageId,
    required this.answers,
  });

  String question;
  int? imageId;
  List<PostQuestionQueryAnswer> answers;

  Map<String, dynamic> toJson() => {
        'question': question,
        'imageId': imageId,
        'answers': answers.map((e) => e.toJson()).toList(),
      };
}

class PostQuestionQueryAnswer {
  PostQuestionQueryAnswer({
    required this.answer,
    required this.isCorrect,
  });

  String answer;
  bool isCorrect;

  Map<String, dynamic> toJson() => {
        'answer': answer,
        'isCorrect': isCorrect,
      };
}
