import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:progressive_image/progressive_image.dart';

import '../bloc/auth_bloc/auth_bloc.dart';
import '../bloc/auth_bloc/auth_state.dart';
import '../bloc/post/post_bloc.dart';
import '../constants/my_colors.dart';
import '../constants/route_name.dart';
import '../constants/string_constants.dart';
import '../num_extensions.dart';
import '../object/post.dart';
import '../utils/date_time_service.dart';
import 'comment_button.dart';
import 'custom_card.dart';
import 'popup/confirmation_dialog.dart';

class PostCard extends HookWidget {
  const PostCard({super.key, required this.post, required this.postBloc});

  final Post post;
  final PostBloc postBloc;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      borderColor: Theme.of(context).colorScheme.tertiary,
      content: Padding(
        padding: const EdgeInsets.all(15.0),
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
                      child: SizedBox(
                        height: 200,
                        width: double.infinity,
                        child: LayoutBuilder(
                          builder: (
                            BuildContext context,
                            BoxConstraints constraints,
                          ) {
                            return ProgressiveImage(
                              placeholder: null,
                              thumbnail: const AssetImage(
                                'assets/images/placeholder.jpg',
                              ),
                              // size: 1.29MB
                              image: NetworkImage(post.image?.url ?? ''),
                              height: constraints.maxHeight,
                              width: constraints.maxWidth,
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: RatingBar(
                    ignoreGestures: true,
                    itemSize: 15,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 2),
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
            20.ph,
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // TODO(nono): à confirmer
                          if (context.read<AuthBloc>().state.user?.poiId !=
                                  null &&
                              context.read<AuthBloc>().state.user?.poiId ==
                                  post.poi.id) {
                            context.go(
                              RouteName.profilePagePoi,
                            );
                          } else {
                            final String? path =
                                ModalRoute.of(context)?.settings.name;
                            if (path != null &&
                                !path.contains(post.poi.id.toString())) {
                              context.push(
                                '${RouteName.monumentPage}/${post.poi.id}',
                              );
                            }
                          }
                        },
                        child: Text(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          post.poi.name,
                          style: TextStyle(
                            shadows: [
                              Shadow(
                                color: Theme.of(context).colorScheme.primary,
                                offset: const Offset(0, -5),
                              ),
                            ],
                            color: Colors.transparent,
                            decoration: TextDecoration.underline,
                            decorationColor:
                                Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      12.ph,
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
            5.ph,
            SizedBox(
              width: double.infinity,
              child: Text(
                post.content,
                style: const TextStyle(fontSize: 15),
              ),
            ),
            5.ph,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (context.read<AuthBloc>().state.user?.id !=
                    post.createdBy.id)
                  GestureDetector(
                    onTap: () {
                      context.push(
                        '${RouteName.profilePage}/${post.createdBy.id}',
                      );
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: post.createdBy.avatar?.url != null
                              ? CachedNetworkImageProvider(
                                  post.createdBy.avatar!.url,
                                )
                              : null,
                          child: post.createdBy.avatar?.url == null
                              ? const Icon(Icons.person)
                              : null,
                        ),
                        5.pw,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateTimeService.formatDateTime(post.createdAt),
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            Text(post.createdBy.username),
                          ],
                        ),
                      ],
                    ),
                  ),
                if (context.read<AuthBloc>().state.user?.id ==
                    post.createdBy.id)
                  Text(
                    DateTimeService.formatDateTime(post.createdAt),
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                const Spacer(),
                IconButton(
                  color: Theme.of(context).colorScheme.primary,
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all(Colors.transparent),
                  ),
                  icon: Icon(
                    post.isLiked ? Icons.favorite : Icons.favorite_border,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () async {
                    if (context.read<AuthBloc>().state.status ==
                        AuthStatus.guest) {
                      await confirmationPopUp(
                        context,
                        title: StringConstants().pleaseLogin,
                        isOkPopUp: true,
                      );
                    } else {
                      if (context.read<AuthBloc>().state.user?.id !=
                          post.createdBy.id) {
                        EasyDebounce.debounce('like_post', Durations.medium1,
                            () async {
                          post.isLiked
                              ? context
                                  .read<PostBloc>()
                                  .add(DislikePostEvent(post.id))
                              : context
                                  .read<PostBloc>()
                                  .add(LikePostEvent(post.id));
                        });
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
                if (post.createdBy.id ==
                    context.read<AuthBloc>().state.user?.id)
                  IconButton(
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all(Colors.transparent),
                    ),
                    icon: Icon(
                      Icons.delete_outline,
                      color: Theme.of(context).colorScheme.primary,
                    ),
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
    final isAnimationRunning = useState(false);
    final controller = useAnimationController(
      duration: const Duration(milliseconds: 500),
    );

    return InkWell(
      onDoubleTap: () =>
          (context.read<AuthBloc>().state.status == AuthStatus.authenticated &&
                  context.read<AuthBloc>().state.user?.id != post.createdBy.id)
              ? handleDoubleTap(
                  controller,
                  context,
                  post,
                  showHeart,
                  showDislike,
                  isAnimationRunning,
                )
              : null,
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

  void handleDoubleTap(
    AnimationController controller,
    BuildContext context,
    Post post,
    ValueNotifier<bool> showHeart,
    ValueNotifier<bool> showDislike,
    ValueNotifier<bool> isAnimationRunning,
  ) {
    if (isAnimationRunning.value) {
      return;
    }

    if (context.read<AuthBloc>().state.status != AuthStatus.authenticated ||
        post.createdBy.id == context.read<AuthBloc>().state.user?.id) {
      return;
    }

    isAnimationRunning.value = true;

    if (post.isLiked) {
      context.read<PostBloc>().add(
            DislikePostEvent(post.id),
          );
      showDislike.value = true;

      controller.forward().then((_) {
        Future.delayed(const Duration(milliseconds: 1200), () {
          showDislike.value = false;
          controller.reset();
          isAnimationRunning.value = false;
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
        isAnimationRunning.value = false;
      });
    });
    return;
  }
}
