class Answer {
  Answer({
    required this.id,
    required this.questionId,
    required this.answer,
    this.isCorrect,
  });
  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
        id: json['id'] as int,
        questionId: json['questionId'] as int,
        answer: json['answer'] as String,
        isCorrect: json['isCorrect'] as bool?,
      );

  int id;
  int questionId;
  String answer;
  bool? isCorrect;

  Map<String, dynamic> toJson() => {
        'id': id,
        'questionId': questionId,
        'answer': answer,
      };

  Answer copyWith({
    int? id,
    int? questionId,
    String? answer,
    bool? isCorrect,
  }) =>
      Answer(
        id: id ?? this.id,
        questionId: questionId ?? this.questionId,
        answer: answer ?? this.answer,
        isCorrect: isCorrect ?? this.isCorrect,
      );
}
