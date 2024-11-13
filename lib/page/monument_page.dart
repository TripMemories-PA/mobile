import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../api/post/post_service.dart';
import '../bloc/monument_bloc/monument_bloc.dart';
import '../bloc/post/post_bloc.dart';
import '../component/post_card.dart';
import '../component/shimmer/shimmer_post_and_monument_resume.dart';
import '../constants/string_constants.dart';
import '../num_extensions.dart';
import '../object/poi/poi.dart';
import '../repository/monument/monument_repository.dart';
import '../repository/post/post_repository.dart';

class MonumentPage extends StatelessWidget {
  const MonumentPage({super.key, required this.monument});

  final Poi monument;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MonumentBloc(
        monumentRepository: RepositoryProvider.of<MonumentRepository>(context),
      )..add(
          GetMonumentEvent(
            id: monument.id,
          ),
        ),
      child: BlocBuilder<MonumentBloc, MonumentState>(
        builder: (context, state) {
          return _PageContent(
            monument: monument,
          );
        },
      ),
    );
  }
}

class _PageContent extends HookWidget {
  const _PageContent({required this.monument});

  final Poi monument;

  @override
  Widget build(BuildContext context) {
    final ScrollController monumentScrollController = useScrollController();
    useEffect(
      () {
        void createScrollListener() {
          if (monumentScrollController.position.atEdge) {
            if (monumentScrollController.position.pixels != 0) {
              _getPosts(context, false);
            }
          }
        }

        monumentScrollController.addListener(createScrollListener);
        return () =>
            monumentScrollController.removeListener(createScrollListener);
      },
      const [],
    );
    return Scaffold(
      body: Center(
        child: ListView(
          controller: monumentScrollController,
          children: [
            _buildHeader(),
            20.ph,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: _buildBody(context),
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
          id: monument.id,
          isRefresh: isRefresh,
        ),
      );
    }
  }

  Column _buildBody(BuildContext context) {
    return Column(
      children: [
        Text(
          monument.name,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
            height: 1,
          ),
        ),
        15.ph,
        Text(
          monument.city?.name ?? '',
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
        15.ph,
        Text(
          monument.description ?? '',
          style: const TextStyle(
            fontSize: 15,
          ),
        ),
        15.ph,
        Text(
          '${StringConstants.lastPostsFrom} ${monument.name}',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
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
                  return Column(
                    children: [
                      ...context
                          .read<MonumentBloc>()
                          .state
                          .selectedMonumentPosts
                          .map(
                            (post) => Column(
                              children: [
                                PostCard(
                                  post: post,
                                  postBloc: context.read<PostBloc>(),
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
                            ? (context.read<MonumentBloc>().state.status !=
                                    MonumentStatus.error
                                ? const ShimmerPostAndMonumentResume()
                                : _buildErrorWidget(context))
                            : const Text(StringConstants.noMorePosts),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
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

  Stack _buildHeader() {
    return Stack(
      children: [
        SizedBox(
          height: 180,
          width: double.infinity,
          child: CachedNetworkImage(
            imageUrl: monument.cover.url,
            fit: BoxFit.cover,
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                Center(
              child: CircularProgressIndicator(
                value: downloadProgress.progress,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.error,
                ),
              ),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
        SizedBox(
          height: 180,
          width: double.infinity,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                monument.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
