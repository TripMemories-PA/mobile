import '../meta_object.dart';
import 'question.dart';

class Quiz {
  Quiz({
    required this.metaObject,
    required this.data,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      metaObject: MetaObject.fromJson(json['meta'] as Map<String, dynamic>),
      data: (json['data'] as List)
          .map((e) => Question.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Quiz copyWith({
    MetaObject? metaObject,
    List<Question>? data,
  }) =>
      Quiz(
        metaObject: metaObject ?? this.metaObject,
        data: data ?? this.data,
      );

  MetaObject metaObject;
  List<Question> data;
}
