import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../api/quiz/model/query/post_question_query.dart';

part 'quiz_event.dart';
part 'quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  QuizBloc() : super(QuizState()) {
    on<QuizEvent>((event, emit) {
      throw UnimplementedError();
    });
    
    on<GetQuizEvent>((event, emit) {
      throw UnimplementedError();
    });
    
    on<UpdateQuestionEvent>((event, emit) {
      throw UnimplementedError();
    });    
    
    on<DeleteQuestionEvent>((event, emit) {
      throw UnimplementedError();
    });    
    
    on<PostQuestionEvent>((event, emit) {
      throw UnimplementedError();
    });    
    
    on<CheckQuestionEvent>((event, emit) {
      throw UnimplementedError();
    });    
    
    on<StoreImageEvent>((event, emit) {
      throw UnimplementedError();
    });
  }
}
