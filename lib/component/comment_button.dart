import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../api/comment/comment_service.dart';
import '../bloc/auth_bloc/auth_bloc.dart';
import '../bloc/auth_bloc/auth_state.dart';
import '../bloc/comment_bloc/comment_bloc.dart';
import '../bloc/post/post_bloc.dart';
import '../constants/route_name.dart';
import '../constants/string_constants.dart';
import '../num_extensions.dart';
import '../object/comment.dart';
import '../object/post.dart';
import '../repository/comment/comment_repository.dart';
import '../utils/date_time_service.dart';
import '../utils/messenger.dart';
import 'popup/confirmation_dialog.dart';
import 'text_field_custom.dart';

class CommentButton extends HookWidget {
  const CommentButton({
    super.key,
    required this.post,
    required this.postBloc,
  });

  final Post post;
  final PostBloc postBloc;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          Colors.transparent,
        ),
      ),
      icon: Icon(
        Icons.chat_bubble_outline,
        color: Theme.of(context).colorScheme.primary,
      ),
      onPressed: () {
        showModalBottomSheet(
          backgroundColor: Theme.of(context).colorScheme.surface,
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return BlocProvider(
              create: (context) => CommentBloc(
                commentRepository: RepositoryProvider.of<CommentRepository>(
                  context,
                ),
                commentService: CommentService(),
                postId: post.id,
                postBloc: postBloc,
              )..add(GetCommentsEvent(isRefresh: true)),
              child: BlocBuilder<CommentBloc, CommentState>(
                builder: (context, state) {
                  return CommentButtonContent(
                    postId: post.id,
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

class CommentButtonContent extends HookWidget {
  const CommentButtonContent({
    super.key,
    required this.postId,
  });

  final int postId;

  void _getComments(BuildContext context) {
    final monumentBloc = context.read<CommentBloc>();

    if (monumentBloc.state.status != CommentStatus.loading) {
      monumentBloc.add(
        GetCommentsEvent(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController commentScrollController = useScrollController();
    final TextEditingController commentController = useTextEditingController();
    useEffect(
      () {
        void createScrollListener() {
          if (commentScrollController.position.atEdge) {
            if (commentScrollController.position.pixels != 0) {
              _getComments(context);
            }
          }
        }

        commentScrollController.addListener(createScrollListener);
        return () =>
            commentScrollController.removeListener(createScrollListener);
      },
      const [],
    );
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      width: double.infinity,
      child: BlocBuilder<CommentBloc, CommentState>(
        builder: (context, state) {
          if (state.status == CommentStatus.error) {
            return _buildErrorWidget(context);
          } else if (state.status == CommentStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.commentResponse == null) {
            return Text(StringConstants().noComments);
          } else {
            return ListView(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30.0),
                    child: Text(
                      StringConstants().comments,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: SingleChildScrollView(
                    controller: commentScrollController,
                    child: Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.commentResponse?.data.length ?? 0,
                          itemBuilder: (context, index) {
                            final Comment comment =
                                (state.commentResponse?.data ?? [])[index];
                            return _buildComment(comment, context);
                          },
                        ),
                        Center(
                          child: state.hasMoreComments
                              ? ElevatedButton(
                                  onPressed: () {
                                    context
                                        .read<CommentBloc>()
                                        .add(GetCommentsEvent());
                                  },
                                  child: Text(
                                    StringConstants().loadMoreResults,
                                  ),
                                )
                              : Text(StringConstants().noMoreComments),
                        ),
                        20.ph,
                      ],
                    ),
                  ),
                ),
                if (context.read<AuthBloc>().state.status ==
                    AuthStatus.authenticated)
                  _buildCommentTextInput(context, commentController),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context) {
    return Column(
      children: [
        Text(StringConstants().errorAppendedWhileGettingData),
        ElevatedButton(
          onPressed: () => _getComments(context),
          child: Text(StringConstants().retry),
        ),
      ],
    );
  }

  Padding _buildCommentTextInput(
    BuildContext context,
    TextEditingController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          BlocListener<CommentBloc, CommentState>(
            listener: (context, state) {
              if (state.error != null) {
                Messenger.showSnackBarError(
                  state.error!.getDescription(),
                );
              } else if (state.addCommentStatus ==
                  CommentStatus.commentPosted) {
                Messenger.showSnackBarSuccess(StringConstants().postedComment);
                controller.clear();
              }
              if (state.status == CommentStatus.reported) {
                Messenger.showSnackBarSuccess(
                  StringConstants().thankyouForYourFeedback,
                );
              }
            },
            child: const SizedBox.shrink(),
          ),
          Expanded(
            child: TextFieldCustom(
              controller: controller,
            ),
          ),
          BlocBuilder<CommentBloc, CommentState>(
            builder: (context, state) {
              final bool isLoading =
                  state.addCommentStatus == CommentStatus.loading;
              return IconButton(
                icon: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (isLoading)
                      CircularProgressIndicator(
                        strokeWidth: 2.0,
                        color: Theme.of(context).colorScheme.surface,
                      )
                    else
                      const Icon(
                        Icons.send,
                        size: 15,
                      ),
                  ],
                ),
                onPressed: () {
                  context.read<CommentBloc>().add(
                        AddCommentEvent(
                          content: controller.text,
                          postId: postId,
                        ),
                      );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildComment(Comment comment, BuildContext context) {
    final String? imageUrl = comment.createdBy.avatar?.url;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (imageUrl != null)
                GestureDetector(
                  onTap: () => context
                      .push('${RouteName.profilePage}/${comment.createdBy.id}'),
                  child: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                      comment.createdBy.avatar?.url ?? '',
                    ),
                  ),
                )
              else
                const Icon(Icons.account_circle, size: 40),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 10.0,
                    right: 10.0,
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          DateTimeService.formatDateTime(comment.createdAt),
                          style: const TextStyle(
                            fontSize: 10,
                          ),
                        ),
                      ),
                      Text(comment.content),
                    ],
                  ),
                ),
              ),
              if (context.read<AuthBloc>().state.status ==
                  AuthStatus.authenticated)
                if (comment.createdBy.id ==
                    context.read<AuthBloc>().state.user?.id)
                  IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        Colors.transparent,
                      ),
                    ),
                    onPressed: () async {
                      final bool result = await confirmationPopUp(
                        context,
                        title: StringConstants().sureToDeleteComment,
                      );
                      if (!result) {
                        return;
                      } else {
                        if (context.mounted) {
                          context
                              .read<CommentBloc>()
                              .add(DeleteCommentEvent(comment.id));
                        }
                      }
                    },
                  )
                else
                  Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              comment.isLiked
                                  ? Icons.favorite
                                  : Icons.favorite_outline,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                Colors.transparent,
                              ),
                            ),
                            onPressed: () async {
                              if (context.read<AuthBloc>().state.status ==
                                  AuthStatus.authenticated) {
                                context.read<CommentBloc>().add(
                                      comment.isLiked
                                          ? DislikeCommentEvent(comment.id)
                                          : LikeCommentEvent(comment.id),
                                    );
                              }
                            },
                          ),
                          Text(comment.likesCount.toString()),
                          10.pw,
                        ],
                      ),
                      5.ph,
                      if (context.read<AuthBloc>().state.status ==
                          AuthStatus.authenticated)
                        IconButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                              Colors.transparent,
                            ),
                          ),
                          onPressed: () {
                            if (comment.isReported ?? false) {
                              Messenger.showSnackBarError(
                                StringConstants().alreadyReported,
                              );
                              return;
                            }
                            confirmationPopUp(
                              context,
                              title: StringConstants().confirmReportComment,
                            ).then((value) {
                              if (value) {
                                context
                                    .read<CommentBloc>()
                                    .add(ReportCommentEvent(comment.id));
                              }
                            });
                          },
                          icon: Icon(
                            comment.isReported ?? false
                                ? Icons.flag
                                : Icons.flag_outlined,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                    ],
                  ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Container(
            width: double.infinity,
            height: 1,
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
      ],
    );
  }
}
