import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../api/meet/meet_service.dart';
import '../bloc/auth_bloc/auth_bloc.dart';
import '../bloc/cart/cart_bloc.dart';
import '../bloc/meet/meet_bloc.dart';
import '../bloc/meet_details/meet_details_bloc.dart';
import '../component/ticket_card.dart';
import '../component/ticket_slider.dart';
import '../constants/route_name.dart';
import '../constants/string_constants.dart';
import '../num_extensions.dart';
import '../object/meet.dart';
import '../object/profile.dart';
import '../object/ticket.dart';
import '../repository/meet/meet_repository.dart';
import '../repository/ticket/ticket_repository.dart';
import '../utils/date_time_service.dart';
import '../utils/messenger.dart';
import 'meet_page.dart';

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
        ticketRepository: RepositoryProvider.of<TicketRepository>(
          context,
        ),
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
          if (state.error != null) {
            Messenger.showSnackBarError(
              state.error?.getDescription() ?? StringConstants().errorOccurred,
            );
          }
        },
        builder: (context, state) {
          final Meet? meet = state.meet;
          final Ticket? ticket = meet?.ticket;
          if (state.meetDetailsQueryStatus == MeetDetailsQueryStatus.loading) {
            return Center(
              child: Lottie.asset('assets/lottie/plane_loader.json'),
            );
          } else {
            return meet == null
                ? Text(StringConstants().noMeetFound)
                : Scaffold(
                    body: RefreshIndicator(
                      onRefresh: () async {
                        context.read<MeetDetailsBloc>().add(
                              GetMeet(
                                meetId: meetId,
                              ),
                            );
                      },
                      child: _buildBody(meet, context, state, ticket),
                    ),
                  );
          }
        },
      ),
    );
  }

  ListView _buildBody(
    Meet meet,
    BuildContext context,
    MeetDetailsState state,
    Ticket? ticket,
  ) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            children: [
              Text(
                meet.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  letterSpacing: 1.5,
                  fontSize: 30,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w900,
                  shadows: [
                    Shadow(
                      offset: const Offset(0.6, 0.6),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    Shadow(
                      offset: const Offset(-0.6, -0.6),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    Shadow(
                      offset: const Offset(0.6, -0.6),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    Shadow(
                      offset: const Offset(-0.6, 0.6),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
              ),
              15.ph,
              Text(
                DateTimeService.formatDateToDayMonthYear(
                  meet.date,
                ),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w900,
                ),
              ),
              15.ph,
              Text(meet.description),
              15.ph,
              Divider(
                color: Theme.of(context).colorScheme.tertiary,
              ),
              15.ph,
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${meet.usersCount} ${StringConstants().participant}${(state.users.length) > 1 ? 's' : ''}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              10.ph,
              Row(
                children: [
                  MeetCardPeople(
                    users: state.users,
                    hasJoined: true,
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text(StringConstants().iParticipate),
                  ),
                ],
              ),
              15.ph,
              Divider(
                color: Theme.of(context).colorScheme.tertiary,
              ),
              15.ph,
            ],
          ),
        ),
        if (ticket != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: _TicketCardToBuy(
              ticket: ticket,
              meetId: meetId,
            ),
          )
        else
          TicketTabView(
            tickets: state.ticketsToBuy,
          ),
        15.ph,
        if (ticket != null) _buildBlueBandana(state),
        _buildExitButton(context, state),
      ],
    );
  }

  Builder _buildBlueBandana(MeetDetailsState state) {
    return Builder(
      builder: (context) {
        final List<Profile> userThatPaid = [];
        for (final Profile user in state.users) {
          if (user.hasPaid ?? false) {
            userThatPaid.add(user);
          }
        }
        return Container(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${StringConstants().already} '
                    '${userThatPaid.length} '
                    '${StringConstants().place}'
                    '${userThatPaid.length > 1 ? 's' : ''} '
                    '${StringConstants().sold}'
                    '${userThatPaid.length > 1 ? 's' : ''}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  10.ph,
                  if (userThatPaid.isNotEmpty)
                    MeetCardPeople(
                      users: userThatPaid,
                      hasJoined: true,
                    )
                  else
                    const SizedBox(),
                ],
              ),
              ElevatedButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => BlocProvider.value(
                    value: context.read<MeetDetailsBloc>(),
                    child: const Dialog(
                      child: _UserList(),
                    ),
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    Colors.transparent,
                  ),
                  side: WidgetStateProperty.all(
                    BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  padding: WidgetStateProperty.all(
                    EdgeInsets.zero,
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 8.0,
                  ),
                  color: Colors.transparent,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.remove_red_eye_outlined,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      10.pw,
                      Text(
                        StringConstants().seeDetail,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  ElevatedButton _buildExitButton(
    BuildContext context,
    MeetDetailsState state,
  ) {
    final bool isLocked = (state.meet?.isLocked ?? false) ||
        state.meet?.createdBy.id == context.read<AuthBloc>().state.user?.id;
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          isLocked
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).colorScheme.primary,
        ),
      ),
      onPressed: () {
        if (isLocked) {
          Messenger.showSnackBarError(StringConstants().meetLocked);
          return;
        }
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
                final int? meetId =
                    context.read<MeetDetailsBloc>().state.meet?.id;
                if (meetId != null) {
                  context
                      .read<MeetDetailsBloc>()
                      .add(GetMeetUsers(meetId: meetId));
                }
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

class _TicketCardToBuy extends HookWidget {
  const _TicketCardToBuy({required this.ticket, required this.meetId});

  final Ticket ticket;
  final int meetId;

  @override
  Widget build(BuildContext context) {
    return TicketCardAdmin(
      article: ticket,
      buyButton: _buildBuyButton(ticket),
    );
  }

  Widget _buildBuyButton(Ticket ticket) {
    return BlocProvider(
      create: (context) => CartBloc()
        ..add(
          AddArticle(
            ticket,
            meetId: meetId,
          ),
        ),
      child: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) {
          if (state.meetBuyStatus == CartStatus.meetTicketBought) {
            context.read<MeetDetailsBloc>().add(
                  GetMeet(
                    meetId: meetId,
                  ),
                );
          }
        },
        builder: (context, state) {
          return GestureDetector(
            onTap: () {
              context.push(
                RouteName.buy,
                extra: context.read<CartBloc>(),
              );
            },
            child: Container(
              height: 40,
              width: 150,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(
                  35,
                ),
              ),
              child: Center(
                child: Text(
                  StringConstants().addArticle,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
