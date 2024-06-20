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
import '../constants/string_constants.dart';
import '../object/post/post.dart';
import '../repository/comment/comment_repository.dart';
import '../service/comment/comment_remote_data_source.dart';
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
                      PostCard(post: post),
                      const SizedBox(height: 10),
                    ],
                  );
                }).toList(),
              ),
            );
          } else {
            return const Center(child: Text('Pas de post à afficher'));
          }
        } else if (state.getMorePostsStatus == PostStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.getMorePostsStatus == PostStatus.error) {
          return const Center(
            child: Text('Erreur lors du chargement des posts'),
          );
        } else {
          return Container();
        }
      },
    );
  }
}

class PostCard extends HookWidget {
  const PostCard({super.key, required this.post});

  final Post post;

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
                CommentButton(post: post),
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
                        title: 'Etes-vous sûr de vouloir supprimer ce post ?',
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
  });

  final Post post;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: MyColors.purple,
      icon: const Icon(Icons.chat_bubble_outline),
      onPressed: () {
        showModalBottomSheet(
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
                )..add(GetCommentsEvent(isRefresh: true)),
                child: BlocBuilder<CommentBloc, CommentState>(
                  builder: (context, state) {
                    return CommentButtonContent();
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
  });

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
      height: 300,
      width: double.infinity,
      child: BlocBuilder<CommentBloc, CommentState>(
        builder: (context, state) {
          if (state.status == CommentStatus.error) {
            return _buildErrorWidget(context);
          } else if (state.searchMoreCommentsStatus == CommentStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.commentResponse == null) {
            return const Text('Aucun commentaire trouvé');
          } else {
            return Column(
              children: [
                const Text('Commentaires'),
                Expanded(
                  child: SingleChildScrollView(
                    controller: commentScrollController,
                    child: Column(
                      children:
                          (state.commentResponse?.data ?? []).map((comment) {
                        return ListTile(
                          title: Text(comment.content),
                          subtitle: Text(comment.createdBy.username),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
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
