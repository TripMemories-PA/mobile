import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../api/meet/meet_service.dart';
import '../bloc/meet/meet_bloc.dart';
import '../bloc/meet_details/meet_details_bloc.dart';
import '../component/custom_card.dart';
import '../constants/string_constants.dart';
import '../object/meet.dart';
import '../object/profile.dart';
import '../repository/meet/meet_repository.dart';

class MeetDetailsPage extends StatelessWidget {
  const MeetDetailsPage({
    super.key,
    required this.meetBloc,
    required this.meetId,
  });

  final MeetBloc meetBloc;
  final int meetId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MeetDetailsBloc(
        meetRepository: RepositoryProvider.of<MeetRepository>(
          context,
        ),
        meetService: MeetService(),
        meetBloc: meetBloc,
      )..add(
          GetMeet(
            meetId: meetId,
          ),
        ),
      child: BlocConsumer<MeetDetailsBloc, MeetDetailsState>(
        listener: (context, state) {
          if (state.leavingMeetStatus == MeetDetailsQueryStatus.left) {
            context.pop();
          }
        },
        builder: (context, state) {
          final Meet? meet = state.meet;
          if (state.meetDetailsQueryStatus == MeetDetailsQueryStatus.loading) {
            return Center(
              child: Lottie.asset('assets/lottie/plane_loader.json'),
            );
          } else {
            return meet == null
                ? const Text('Meet not found')
                : Scaffold(
                    body: Column(
                      children: [
                        const Center(
                          child: Text('Meet Details Page'),
                        ),
                        Text(meet.title),
                        Text(meet.description),
                        const _UserList(),
                        _buildExitButton(context, state),
                      ],
                    ),
                  );
          }
        },
      ),
    );
  }

  ElevatedButton _buildExitButton(
    BuildContext context,
    MeetDetailsState state,
  ) {
    return ElevatedButton(
      onPressed: () {
        context.read<MeetDetailsBloc>().add(LeaveMeetEvent());
      },
      child: Row(
        children: [
          const Icon(Icons.exit_to_app),
          Text(StringConstants().leaveMeet),
          const Spacer(),
          if (state.leavingMeetStatus == MeetDetailsQueryStatus.loading)
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 12,
              ),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _UserList extends HookWidget {
  const _UserList();

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
                context.read<MeetDetailsBloc>().add(GetMeetUsers());
              }
            }
          }
        }

        scrollController.addListener(createScrollListener);
        return () => scrollController.removeListener(createScrollListener);
      },
      const [],
    );
    return BlocBuilder<MeetDetailsBloc, MeetDetailsState>(
      builder: (context, state) {
        return state.getUsersLoadingStatus == MeetDetailsQueryStatus.loading
            ? const CircularProgressIndicator()
            : Column(
          children: List.generate(
            state.users.length + 1,
                (index) {
              if (index == state.users.length) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(StringConstants().noMoreUsers),
                  ),
                );
              }
              final Profile user = state.users[index];
              return ListTile(
                title: Text(user.username),
                subtitle: Text(user.email),
              );
            },
          ),
        );
      },
    );
  }
}
