class CheckQuestionResponse {
  CheckQuestionResponse({
    required this.isCorrect,
  });

  factory CheckQuestionResponse.fromJson(Map<String, dynamic> json) =>
      CheckQuestionResponse(
        isCorrect: json['isCorrect'] as bool,
      );

  bool isCorrect;
}
