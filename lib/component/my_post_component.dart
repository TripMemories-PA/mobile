import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip_memories_mobile/component/shimmer/shimmer_post_and_monument_resume_grid.dart';

import '../bloc/post/post_bloc.dart';
import '../constants/string_constants.dart';
import '../object/post/post.dart';
import 'post_card.dart';

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
        } else if (state.status == PostStatus.loading) {
          return Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.90,
              height: MediaQuery.of(context).size.height * 0.30,
              child: const ShimmerPostAndMonumentResumeGrid(),
            ),
          );
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
