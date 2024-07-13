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
import '../object/profile.dart';
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
                onPressed: context.pop,
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

                          return _MeetPreviewCard(
                            meet: meet,
                            state: state,
                            key: Key(meet.id.toString()),
                          );
                        },
                      ),
                    )),
        );
      },
    );
  }
}

class _MeetPreviewCard extends StatelessWidget {
  const _MeetPreviewCard({
    super.key,
    required this.meet,
    required this.state,
  });

  final Meet meet;
  final MeetState state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: CustomCard(
        borderColor: Theme.of(context).colorScheme.tertiary,
        content: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              const SizedBox(height: 16),
              SizedBox(
                height: 108,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        width: 128,
                        meet.poi.cover.url,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            meet.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: Text(
                              meet.description,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _MeetCardPeople(
                users: meet.users ?? [],
                hasJoined: meet.hasJoined ?? false,
              ),
              const SizedBox(height: 8),
              if (context.read<AuthBloc>().state.user?.userTypeId != 3 &&
                  context.read<AuthBloc>().state.status ==
                      AuthStatus.authenticated)
                _JoinMeetButton(meet: meet, state: state),
            ],
          ),
        ),
      ),
    );
  }
}

class _MeetCardPeople extends StatelessWidget {
  const _MeetCardPeople({
    required this.users,
    this.hasJoined = false,
  });

  final List<Profile> users;
  final bool hasJoined;

  @override
  Widget build(BuildContext context) {
    const maxCircles = 3;
    final length = maxCircles.clamp(0, users.length);
    const width = 32.0;
    const height = 32.0;
    const overlapAmount = 10.0;
    final rest = users.length - length;
    var otherUsers = users;

    if (otherUsers.length > maxCircles) {
      otherUsers = otherUsers
          .where((u) => u.id != context.read<AuthBloc>().state.user?.id)
          .toList();
      otherUsers = otherUsers.sublist(0, length);
    }

    return Row(
      children: [
        SizedBox(
          width: width * length - overlapAmount * (length - 1),
          height: height,
          child: Stack(
            children: otherUsers
                .asMap()
                .entries
                .map(
                  (kvp) => Positioned(
                    left: (width - overlapAmount) * kvp.key,
                    child: Container(
                      width: width,
                      height: height,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: .5,
                            blurRadius: 1,
                            offset: const Offset(-1, 0),
                          ),
                        ],
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: ClipOval(
                        child: kvp.value.avatar == null
                            ? const Center(child: Icon(Icons.person))
                            : Image.network(kvp.value.avatar!.url),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        const SizedBox(width: 8),
        if (hasJoined && length > maxCircles) Text('${StringConstants().you} '),
        if (rest > 0) Text('+ $rest'),
      ],
    );
  }
}

class _JoinMeetButton extends StatelessWidget {
  const _JoinMeetButton({required this.meet, required this.state});

  final Meet meet;
  final MeetState state;

  @override
  Widget build(BuildContext context) {
    final bool isLoading = state.joinMeetStatus == JoinMeetStatus.loading &&
        state.selectedMeetId == meet.id;

    return ElevatedButton(
      onPressed: isLoading
          ? null
          : () {
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
      child: Center(
        child: isLoading
            ? const SizedBox.square(
                dimension: 20,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                (meet.hasJoined ?? false)
                    ? StringConstants().seeMeet
                    : StringConstants().joinMeet,
              ),
      ),
    );
  }
}
