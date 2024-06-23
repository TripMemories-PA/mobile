import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../bloc/auth_bloc/auth_bloc.dart';
import '../bloc/auth_bloc/auth_state.dart';
import '../bloc/post/post_bloc.dart';
import '../constants/my_colors.dart';
import '../constants/route_name.dart';
import '../constants/string_constants.dart';
import '../object/post/post.dart';
import 'comment_button.dart';
import 'custom_card.dart';
import 'popup/confirmation_logout_dialog.dart';

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
                        '${post.poi.city?.name} - ${post.poi.city?.zipCode}',
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
                    color: Colors.red,
                  ),
                  onPressed: () async {
                    if (context.read<AuthBloc>().state.status ==
                        AuthStatus.guest) {
                      final bool result = await confirmationPopUp(
                        context,
                        title: StringConstants().pleaseLogin,
                      );
                      if (!result) {
                        return;
                      } else {
                        if (context.mounted) {
                          context.go(RouteName.loginPage);
                        }
                      }
                    } else {
                      if (context.read<AuthBloc>().state.user?.id !=
                          post.createdBy.id) {
                        post.isLiked
                            ? context
                                .read<PostBloc>()
                                .add(DislikePostEvent(post.id))
                            : context
                                .read<PostBloc>()
                                .add(LikePostEvent(post.id));
                      }
                    }
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

class PostCardLikable extends HookWidget {
  const PostCardLikable({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    final showHeart = useState(false);
    final showDislike = useState(false);
    final controller = useAnimationController(
      duration: const Duration(milliseconds: 500),
    );

    void handleDoubleTap() {
      if (context.read<AuthBloc>().state.status != AuthStatus.authenticated ||
          post.createdBy.id == context.read<AuthBloc>().state.user?.id) {
        return;
      }

      if (post.isLiked) {
        context.read<PostBloc>().add(
              DislikePostEvent(post.id),
            );
        showDislike.value = true;
        controller.forward().then((_) {
          Future.delayed(const Duration(milliseconds: 1200), () {
            showDislike.value = false;
            controller.reset();
          });
        });
        return;
      }

      context.read<PostBloc>().add(
            LikePostEvent(post.id),
          );
      showHeart.value = true;
      controller.forward().then((_) {
        Future.delayed(const Duration(milliseconds: 2000), () {
          showHeart.value = false;
          controller.reset();
        });
      });
    }

    return InkWell(
      onDoubleTap: handleDoubleTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PostCard(
            post: post,
            postBloc: context.read<PostBloc>(),
          ),
          if (showHeart.value)
            Lottie.asset(
              'assets/lottie/like_animation.json',
              width: 200,
              height: 200,
              fit: BoxFit.fill,
            ),
          if (showDislike.value)
            Lottie.asset(
              'assets/lottie/dislike_animation.json',
              width: 200,
              height: 200,
              fit: BoxFit.fill,
            ),
        ],
      ),
    );
  }
}
