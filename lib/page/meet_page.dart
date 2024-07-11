import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../bloc/meet/meet_bloc.dart';
import '../repository/meet/meet_repository.dart';

class MeetPage extends HookWidget {
  const MeetPage({super.key, required this.poiId});

  final int poiId;

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    useEffect(
      () {
        void createScrollListener() {
          if (scrollController.position.atEdge) {
            if (scrollController.position.pixels != 0) {
              if (context.read<MeetBloc>().state.hasMoreMeets &&
                  context.read<MeetBloc>().state.getMoreMeetsStatus ==
                      MeetQueryStatus.notLoading &&
                  context.read<MeetBloc>().state.meetQueryStatus ==
                      MeetQueryStatus.notLoading) {
                context.read<MeetBloc>().add(GetPoiMeet(poiId: poiId));
              }
            }
          }
        }

        scrollController.addListener(createScrollListener);
        return () => scrollController.removeListener(createScrollListener);
      },
      const [],
    );
    return BlocProvider(
      create: (context) => MeetBloc(
        meetRepository: RepositoryProvider.of<MeetRepository>(
          context,
        ),
      )..add(
          GetPoiMeet(
            poiId: poiId,
          ),
        ),
      child: BlocBuilder<MeetBloc, MeetState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Meet'),
              leading: const SizedBox.shrink(),
              actions: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    context.pop();
                  },
                ),],
            ),
            body: state.meetQueryStatus == MeetQueryStatus.loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : state.meets.isEmpty
                    ? const Center(
                        child: Text('No meets found'),
                      )
                    : ListView.builder(
                        controller: ScrollController(),
                        itemCount: state.hasMoreMeets
                            ? state.meets.length + 1
                            : state.meets.length,
                        itemBuilder: (context, index) {
                          if (index == state.meets.length) {
                            return const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(
                                child: Text('Plus de meets disponibles'),
                              ),
                            );
                          }

                          final meet = state.meets[index];
                          return ListTile(
                            title: Text(meet.title),
                            subtitle: Text(meet.description),
                            trailing: Text(meet.date.toString()),
                          );
                        },
                      ),
          );
        },
      ),
    );
  }
}
