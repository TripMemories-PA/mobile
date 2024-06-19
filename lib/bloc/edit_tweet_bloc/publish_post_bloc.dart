import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../api/error/api_error.dart';
import '../../api/exception/custom_exception.dart';
import '../../api/post/i_post_service.dart';
import '../../api/post/model/query/create_post/create_post_query.dart';
import '../../api/post/model/query/update_post_query/update_post_query.dart';
import '../../object/post/post.dart';

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

    on<UpdatePostRequested>((event, emit) async {
      emit(state.copyWith(status: EditTweetStatus.loading));
      try {
        int? imageId;
        final XFile? image = event.image;
        if (image != null) {
          imageId = await postService.publishImage(image: image);
        }
        await postService.updatePost(
          query: UpdatePostQuery(
            postId: event.post.id,
            content: event.post.content,
            poiId: event.post.poiId,
            note: event.post.note,
            imageId: imageId,
          ),
        );
        emit(state.copyWith(status: EditTweetStatus.updated));
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
