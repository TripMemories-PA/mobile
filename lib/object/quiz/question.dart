import '../poi/poi.dart';
import '../uploaded_file.dart';
import 'answer.dart';

class Question {
  Question({
    required this.id,
    required this.question,
    this.imageId,
    required this.poiId,
    this.image,
    required this.answers,
    required this.poi,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as int,
      question: json['question'] as String,
      imageId: json['imageId'] as int?,
      poiId: json['poiId'] as int,
      image: json['image'] == null
          ? null
          : UploadFile.fromJson(json['image'] as Map<String, dynamic>),
      answers: (json['answers'] as List)
          .map((e) => Answer.fromJson(e as Map<String, dynamic>))
          .toList(),
      poi: Poi.fromJson(json['poi'] as Map<String, dynamic>),
    );
  }

  Question copyWith({
    int? id,
    String? question,
    int? imageId,
    int? poiId,
    UploadFile? image,
    List<Answer>? answers,
    Poi? poi,
  }) =>
      Question(
        id: id ?? this.id,
        question: question ?? this.question,
        imageId: imageId ?? this.imageId,
        poiId: poiId ?? this.poiId,
        image: image ?? this.image,
        answers: answers ?? this.answers,
        poi: poi ?? this.poi,
      );

  int id;
  String question;
  int? imageId;
  int poiId;
  UploadFile? image;
  List<Answer> answers;
  Poi poi;
}
