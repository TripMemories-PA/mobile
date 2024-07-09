class PostQuestionQuery {
  PostQuestionQuery({
    required this.question,
    required this.imageId,
    required this.answers,
  });

  String question;
  int imageId;
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
