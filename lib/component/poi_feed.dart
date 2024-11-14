import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../api/post/post_service.dart';
import '../bloc/monument_bloc/monument_bloc.dart';
import '../bloc/post/post_bloc.dart';
import '../constants/string_constants.dart';
import '../num_extensions.dart';
import '../repository/monument/monument_repository.dart';
import '../repository/post/post_repository.dart';
import 'post_card.dart';
import 'shimmer/shimmer_post_and_monument_resume.dart';

class PoiFeed extends StatelessWidget {
  const PoiFeed({super.key, required this.monumentId});

  final int monumentId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MonumentBloc(
        monumentRepository: RepositoryProvider.of<MonumentRepository>(context),
      )..add(
          GetMonumentEvent(
            id: monumentId,
          ),
        ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            15.ph,
            BlocProvider(
              create: (context) => PostBloc(
                postRepository: RepositoryProvider.of<PostRepository>(context),
                postService: PostService(),
              ),
              child: BlocBuilder<PostBloc, PostState>(
                builder: (context, state) {
                  return BlocBuilder<MonumentBloc, MonumentState>(
                    builder: (context, state) {
                      return Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            _getPosts(context, true);
                          },
                          child: state.selectedPostGetMonumentsStatus ==
                                  MonumentStatus.loading
                              ? const CircularProgressIndicator()
                              : ListView(
                                  children: [
                                    ...context
                                        .read<MonumentBloc>()
                                        .state
                                        .selectedMonumentPosts
                                        .map(
                                          (post) => Column(
                                            children: [
                                              PostCardLikable(
                                                post: post,
                                              ),
                                              20.ph,
                                            ],
                                          ),
                                        ),
                                    Center(
                                      child: context
                                              .read<MonumentBloc>()
                                              .state
                                              .getMonumentsHasMorePosts
                                          ? (context
                                                      .read<MonumentBloc>()
                                                      .state
                                                      .status !=
                                                  MonumentStatus.error
                                              ? const ShimmerPostAndMonumentResume()
                                              : _buildErrorWidget(context))
                                          : const Text(StringConstants.noMorePosts),
                                    ),
                                  ],
                                ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _getPosts(BuildContext context, bool isRefresh) {
    final monumentBloc = context.read<MonumentBloc>();

    if (monumentBloc.state.selectedPostGetMonumentsStatus !=
        MonumentStatus.loading) {
      monumentBloc.add(
        GetMonumentPostsEvent(
          id: monumentId,
          isRefresh: isRefresh,
        ),
      );
    }
  }

  Widget _buildErrorWidget(BuildContext context) {
    return Column(
      children: [
        const Text(StringConstants.errorAppendedWhileGettingData),
        ElevatedButton(
          onPressed: () => _getPosts(context, true),
          child: const Text(StringConstants.retry),
        ),
      ],
    );
  }
}
