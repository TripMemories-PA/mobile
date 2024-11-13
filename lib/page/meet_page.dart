import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../api/meet/meet_service.dart';
import '../api/meet/model/query/update_meet_query.dart';
import '../bloc/auth_bloc/auth_bloc.dart';
import '../bloc/auth_bloc/auth_state.dart';
import '../bloc/meet/meet_bloc.dart';
import '../component/custom_card.dart';
import '../component/form/edit_meet_form.dart';
import '../component/popup/confirmation_dialog.dart';
import '../constants/route_name.dart';
import '../constants/string_constants.dart';
import '../dto/meet_bloc_and_obj_dto.dart';
import '../num_extensions.dart';
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
        if (state.deleteMeetStatus == DeleteMeetStatus.deleted) {
          Messenger.showSnackBarSuccess(StringConstants().meetDeleted);
        }
        if (state.deleteMeetStatus == DeleteMeetStatus.error) {
          Messenger.showSnackBarError(StringConstants().meetDeleteFailed);
        }
        if (state.updateMeetStatus == UpdateMeetStatus.updated) {
          Messenger.showSnackBarSuccess(StringConstants().meetUpdated);
        }
        if (state.updateMeetStatus == UpdateMeetStatus.error) {
          Messenger.showSnackBarError(StringConstants().meetUpdateFailed);
        }
      },
      builder: (context, state) {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () => context.push(
              RouteName.editMeet,
              extra: MeetBlocAndObjDTO(
                meetBloc: context.read<MeetBloc>(),
                poi: poi,
              ),
            ),
            child: const Icon(Icons.add),
          ),
          appBar: AppBar(
            leading: Column(
              children: [
                20.ph,
                Text(
                  textAlign: TextAlign.left,
                  StringConstants().meets,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondary,
                    fontSize: 25,
                  ),
                ),
              ],
            ),
            leadingWidth: 150,
            actions: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: context.pop,
              ),
              10.pw,
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
                          if (index == 0) {
                            final meet = state.meets[index];
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      20.ph,
                                      Text(
                                        StringConstants().meetPresentation,
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSecondary,
                                          fontSize: 15,
                                        ),
                                      ),
                                      20.ph,
                                      Text(
                                        StringConstants().bonVoyage,
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSecondary,
                                          fontSize: 15,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                      10.ph,
                                    ],
                                  ),
                                ),
                                _MeetPreviewCard(
                                  meet: meet,
                                  state: state,
                                  key: Key(meet.id.toString()),
                                ),
                              ],
                            );
                          }

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
              16.ph,
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
                    16.pw,
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
                          8.ph,
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
              16.ph,
              Row(
                children: [
                  MeetCardPeople(
                    users: meet.users ?? [],
                    hasJoined: meet.hasJoined ?? false,
                  ),
                  const Spacer(),
                  if (meet.createdBy.id ==
                      context.read<AuthBloc>().state.user?.id)
                    _ActionButtons(meet: meet),
                ],
              ),
              8.ph,
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

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({
    required this.meet,
  });

  final Meet meet;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(Icons.more_vert),
      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.edit_outlined),
            title: Text(StringConstants().editMeet),
          ),
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => DtoMeetBloc(
                meetBloc: context.read<MeetBloc>(),
                child: Dialog(
                  child: Stack(
                    children: [
                      ListView(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(25),
                        children: [
                          30.ph,
                          Text(
                            StringConstants().editMeet,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          30.ph,
                          EditMeetForm(
                            title: meet.title,
                            description: meet.description,
                            onValidate: ({
                              required title,
                              required description,
                            }) {
                              final UpdateMeetQuery query = UpdateMeetQuery(
                                id: meet.id,
                                title: title,
                                description: description,
                              );
                              context.read<MeetBloc>().add(
                                    UpdateMeet(
                                      query: query,
                                    ),
                                  );
                              context.pop();
                            },
                          ),
                        ],
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: context.pop,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.delete_outline),
            title: Text(StringConstants().deleteMeet),
          ),
          onTap: () {
            confirmationPopUp(
              context,
              title: StringConstants().warning,
              content: Text(StringConstants().aboutToDeleteMeet),
            ).then((value) {
              if (value && context.mounted) {
                context.read<MeetBloc>().add(DeleteMeet(meetId: meet.id));
              }
            });
          },
        ),
      ],
    );
  }
}

class MeetCardPeople extends StatelessWidget {
  const MeetCardPeople({
    super.key,
    required this.users,
    this.hasJoined = false,
    this.maxUserAvatar = 3,
    this.avatarSize = 32,
    this.overlapAmount = 10,
  });

  final List<Profile> users;
  final bool hasJoined;
  final int maxUserAvatar;
  final double avatarSize;
  final double overlapAmount;

  @override
  Widget build(BuildContext context) {
    final length = maxUserAvatar.clamp(0, users.length);
    const overlapAmount = 10.0;
    final rest = users.length - length;
    var otherUsers = users;

    if (otherUsers.length > maxUserAvatar) {
      otherUsers = otherUsers
          .where((u) => u.id != context.read<AuthBloc>().state.user?.id)
          .toList();
      otherUsers = otherUsers.sublist(0, length);
    }

    return Row(
      children: [
        SizedBox(
          width: avatarSize * length - overlapAmount * (length - 1),
          height: avatarSize,
          child: Stack(
            children: otherUsers
                .asMap()
                .entries
                .map(
                  (kvp) => Positioned(
                    left: (avatarSize - overlapAmount) * kvp.key,
                    child: GestureDetector(
                      onTap: () {
                        context.push(
                          '${RouteName.profilePage}/${kvp.value.id}',
                        );
                      },
                      child: Container(
                        width: avatarSize,
                        height: avatarSize,
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).colorScheme.surfaceContainerLow,
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
                  ),
                )
                .toList(),
          ),
        ),
        8.pw,
        if (hasJoined && length > maxUserAvatar)
          Text('${StringConstants().you} '),
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
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

class DtoMeetBloc extends StatelessWidget {
  const DtoMeetBloc({super.key, required this.child, required this.meetBloc});

  final Widget child;
  final MeetBloc meetBloc;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
