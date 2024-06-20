import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';

import '../api/comment/comment_service.dart';
import '../bloc/auth_bloc/auth_bloc.dart';
import '../bloc/comment_bloc/comment_bloc.dart';
import '../bloc/post/post_bloc.dart';
import '../constants/my_colors.dart';
import '../constants/route_name.dart';
import '../constants/string_constants.dart';
import '../num_extensions.dart';
import '../object/comment/comment.dart';
import '../object/post/post.dart';
import '../repository/comment/comment_repository.dart';
import '../service/comment/comment_remote_data_source.dart';
import '../utils/messenger.dart';
import 'custom_card.dart';
import 'popup/confirmation_logout_dialog.dart';

class MyPostsComponents extends StatelessWidget {
  const MyPostsComponents({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildPostList(context);
  }

  Widget _buildPostList(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        if (state.getMorePostsStatus == PostStatus.notLoading) {
          final List<Post>? posts = state.posts?.data;
          if (posts != null && posts.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: posts.map((post) {
                  return Column(
                    children: [
                      PostCard(post: post, postBloc: context.read<PostBloc>()),
                      const SizedBox(height: 10),
                    ],
                  );
                }).toList(),
              ),
            );
          } else {
            return Center(child: Text(StringConstants().noPostYet));
          }
        } else if (state.getMorePostsStatus == PostStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.getMorePostsStatus == PostStatus.error) {
          return Center(
            child: Text(StringConstants().errorWhileLoadingPosts),
          );
        } else {
          return Container();
        }
      },
    );
  }
}

class PostCard extends HookWidget {
  const PostCard({super.key, required this.post, required this.postBloc});

  final Post post;
  final PostBloc postBloc;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      content: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            _PostImage(post: post),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  child: Hero(
                    tag: post.id,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(15.0),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: post.image?.url ?? '',
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: RatingBar(
                    ignoreGestures: true,
                    glow: false,
                    initialRating: double.tryParse(post.note) ?? 0,
                    minRating: 1,
                    maxRating: 5,
                    allowHalfRating: true,
                    ratingWidget: RatingWidget(
                      full: Icon(
                        Icons.star,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      half: Icon(
                        Icons.star_half,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      empty: Icon(
                        Icons.star,
                        color: Theme.of(context).colorScheme.surfaceTint,
                      ),
                    ),
                    onRatingUpdate: (double value) {},
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${post.poi.city} - ${post.poi.zipCode}',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        post.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: Text(
                post.content,
                style: const TextStyle(fontSize: 15),
              ),
            ),
            Row(
              children: [
                IconButton(
                  color: MyColors.purple,
                  icon: Icon(
                    post.isLiked ? Icons.favorite : Icons.favorite_border,
                  ),
                  onPressed: () {
                    post.isLiked
                        ? context
                            .read<PostBloc>()
                            .add(DislikePostEvent(post.id))
                        : context.read<PostBloc>().add(LikePostEvent(post.id));
                  },
                ),
                Text(
                  post.likesCount.toString(),
                  style: const TextStyle(color: MyColors.purple),
                ),
                const SizedBox(width: 5),
                CommentButton(
                  post: post,
                  postBloc: postBloc,
                ),
                Text(
                  post.commentsCount.toString(),
                  style: const TextStyle(color: MyColors.purple),
                ),
                const Expanded(child: SizedBox()),
                if (post.createdBy.id ==
                    context.read<AuthBloc>().state.user?.id)
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      final bool result = await confirmationPopUp(
                        context,
                        title: StringConstants().sureToDeletePost,
                      );
                      if (!result) {
                        return;
                      } else {
                        if (context.mounted) {
                          context
                              .read<PostBloc>()
                              .add(DeletePostEvent(post.id));
                        }
                      }
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

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
      color: MyColors.purple,
      icon: const Icon(Icons.chat_bubble_outline),
      onPressed: () {
        showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return RepositoryProvider(
              create: (context) => CommentRepository(
                CommentRemoteDataSource(),
                CommentService(),
              ),
              child: BlocProvider(
                create: (context) => CommentBloc(
                  commentRepository: RepositoryProvider.of<CommentRepository>(
                    context,
                  ),
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
                20.ph,
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
                              ? (state.searchMoreCommentsStatus !=
                                      CommentStatus.error
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
                                  : _buildErrorWidget(context))
                              : Text(StringConstants().noMoreComments),
                        ),
                        20.ph,
                      ],
                    ),
                  ),
                ),
                _buildCommentTextInput(context, commentController),
              ],
            );
          }
        },
      ),
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
                Messenger.showSnackBarSuccess('Commentaire posté');
                controller.clear();
              }
            },
            child: const SizedBox.shrink(),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Ecrire un commentaire',
                  hintStyle: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
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
            crossAxisAlignment: CrossAxisAlignment.start,
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
                const Icon(Icons.account_circle),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 10.0,
                    right: 10.0,
                    bottom: 10.0,
                  ),
                  child: Text(comment.content),
                ),
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

class _PostImage extends StatelessWidget {
  const _PostImage({required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pop(context);
      },
      child: Scaffold(
        body: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            Center(
              child: Hero(
                tag: post.id,
                child: InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 5.0,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: CachedNetworkImage(
                      imageUrl: post.image?.url ?? '',
                      width: double.infinity,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
