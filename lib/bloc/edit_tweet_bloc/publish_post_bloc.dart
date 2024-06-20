import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../api/error/api_error.dart';
import '../../api/exception/custom_exception.dart';
import '../../api/post/i_post_service.dart';
import '../../api/post/model/query/create_post/create_post_query.dart';

part 'publish_post_event.dart';
part 'publish_post_state.dart';

class PublishPostBloc extends Bloc<PublishPostEvent, PublishPostState> {
  PublishPostBloc({required this.postService})
      : super(const PublishPostState()) {
    on<PostTweetRequested>((event, emit) async {
      emit(state.copyWith(status: EditTweetStatus.loading));
      try {
        int? imageId;
        if (event.image != null) {
          imageId = await postService.publishImage(image: event.image!);
        }
        await postService.createPost(
          query: CreatePostQuery(
            title: event.title,
            content: event.content,
            poiId: event.monumentId,
            note: event.rating,
            imageId: imageId,
          ),
        );
        emit(state.copyWith(status: EditTweetStatus.posted));
      } catch (e) {
        if (e is CustomException) {
          emit(
            state.copyWith(error: e.apiError, status: EditTweetStatus.error),
          );
        } else {
          emit(
            state.copyWith(
              error: ApiError.errorOccurred(),
              status: EditTweetStatus.error,
            ),
          );
        }
      }
    });
  }

  IPostService postService;
}
