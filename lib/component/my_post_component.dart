import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';

import '../bloc/auth_bloc/auth_bloc.dart';
import '../bloc/post/post_bloc.dart';
import '../constants/my_colors.dart';
import '../constants/route_name.dart';
import '../object/post/post.dart';
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
                ClipRRect(
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
                Positioned(
                  top: 10,
                  right: 10,
                  child: Column(
                    children: [
                      RatingBar(
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
                      const Text(
                        '(1245 avis)',
                        style: TextStyle(color: MyColors.purple),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.createdBy.username,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                    ),
                    const Text(
                      'Une vue incroyable !',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
                const Expanded(child: SizedBox()),
                SizedBox(
                  height: 30,
                  width: 30,
                  child: IconButton(
                    iconSize: 20,
                    icon: const Icon(
                      Icons.edit,
                    ),
                    onPressed: () {
                      context.push(RouteName.editTweetPage, extra: post);
                    },
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
                IconButton(
                  color: MyColors.purple,
                  icon: const Icon(Icons.chat_bubble_outline),
                  onPressed: () {},
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
