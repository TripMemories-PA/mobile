import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../api/meet/meet_service.dart';
import '../bloc/auth_bloc/auth_bloc.dart';
import '../bloc/auth_bloc/auth_state.dart';
import '../bloc/meet/meet_bloc.dart';
import '../component/custom_card.dart';
import '../constants/route_name.dart';
import '../constants/string_constants.dart';
import '../dto/meet_bloc_and_obj_dto.dart';
import '../object/meet.dart';
import '../object/poi/poi.dart';
import '../repository/meet/meet_repository.dart';
import '../utils/messenger.dart';

class MeetPage extends StatelessWidget {
  const MeetPage({super.key, required this.poi});

  final Poi poi;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MeetBloc(
        meetRepository: RepositoryProvider.of<MeetRepository>(
          context,
        ),
        meetService: MeetService(),
      )..add(
          GetPoiMeet(
            poiId: poi.id,
            isRefresh: true,
          ),
        ),
      child: _MeetPageBody(poi),
    );
  }
}

class _MeetPageBody extends HookWidget {
  const _MeetPageBody(this.poi);

  final Poi poi;

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
                context.read<MeetBloc>().add(
                      GetPoiMeet(
                        poiId: poi.id,
                      ),
                    );
              }
            }
          }
        }

        scrollController.addListener(createScrollListener);
        return () => scrollController.removeListener(createScrollListener);
      },
      const [],
    );
    return BlocConsumer<MeetBloc, MeetState>(
      listener: (context, state) {
        if (state.joinMeetStatus == JoinMeetStatus.accepted) {
          Messenger.showSnackBarSuccess(StringConstants().meetJoined);
        } else if (state.joinMeetStatus == JoinMeetStatus.rejected) {
          Messenger.showSnackBarError(StringConstants().meetJoinFailed);
        }
        if (state.meetQueryStatus == MeetQueryStatus.error) {
          Messenger.showSnackBarError(
            state.error?.getDescription() ?? StringConstants().errorOccurred,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Meet'),
            leading: const SizedBox.shrink(),
            actions: [
              ElevatedButton(
                onPressed: () => context.push(
                  RouteName.editMeet,
                  extra: MeetBlocAndObjDTO(
                    meetBloc: context.read<MeetBloc>(),
                    poi: poi,
                  ),
                ),
                child: Text(
                  StringConstants().createMeet,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  context.pop();
                },
              ),
            ],
          ),
          body: state.meetQueryStatus == MeetQueryStatus.loading
              ? Center(
                  child: Lottie.asset(
                    'assets/lottie/plane_loader.json',
                    width: 200,
                    height: 200,
                  ),
                )
              : (state.meets.isEmpty
                  ? Center(
                      child: Text(StringConstants().noMeetFound),
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        context.read<MeetBloc>().add(
                              GetPoiMeet(
                                poiId: poi.id,
                                isRefresh: true,
                              ),
                            );
                      },
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: state.meets.length + 1,
                        itemBuilder: (context, index) {
                          if (index == state.meets.length) {
                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Center(
                                child: Text(StringConstants().noMoreMeets),
                              ),
                            );
                          }

                          final meet = state.meets[index];
                          return _buildMeetPreviewCard(meet, context, state);
                        },
                      ),
                    )),
        );
      },
    );
  }

  CustomCard _buildMeetPreviewCard(
    Meet meet,
    BuildContext context,
    MeetState state,
  ) {
    return CustomCard(
      content: Column(
        children: [
          ListTile(
            title: Text(meet.title),
            subtitle: Text(meet.description),
            trailing: Text(meet.date.toString()),
          ),
          Column(
            children: [
              for (final user in meet.users ?? [])
                ListTile(
                  title: Text(user.username),
                  subtitle: Text(user.email),
                ),
            ],
          ),
          if (context.read<AuthBloc>().state.user?.userTypeId != 3 &&
              context.read<AuthBloc>().state.status == AuthStatus.authenticated)
            _buildJoinMeetButton(meet, context, state),
        ],
      ),
    );
  }

  ElevatedButton _buildJoinMeetButton(
    Meet meet,
    BuildContext context,
    MeetState state,
  ) {
    return ElevatedButton(
      onPressed: () {
        if (meet.hasJoined ?? false) {
          context.push(
            '${RouteName.meet}/${meet.id}',
            extra: context.read<MeetBloc>(),
          );
        } else {
          if (meet.canJoin ?? false) {
            context.read<MeetBloc>().add(AskToJoinMeet(meetId: meet.id));
          }
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: (meet.hasJoined ?? false)
            ? null
            : ((meet.canJoin ?? false) ? null : Colors.grey),
      ),
      child: Row(
        children: [
          Text(
            (meet.hasJoined ?? false)
                ? StringConstants().seeMeet
                : StringConstants().joinMeet,
          ),
          const Spacer(),
          if (state.joinMeetStatus == JoinMeetStatus.loading &&
              state.selectedMeetId == meet.id)
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
