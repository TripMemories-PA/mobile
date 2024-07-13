import 'package:auto_size_text/auto_size_text.dart';
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
import '../component/custom_card.dart';
import '../component/popup/confirmation_dialog.dart';
import '../component/ticket_card.dart';
import '../component/ticket_slider.dart';
import '../constants/route_name.dart';
import '../constants/string_constants.dart';
import '../num_extensions.dart';
import '../object/meet.dart';
import '../object/profile.dart';
import '../object/ticket.dart';
import '../object/uploaded_file.dart';
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
          if (state.deleteUserStatus == DeleteUserStatus.deleted) {
            Messenger.showSnackBarSuccess(StringConstants().userKicked);
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
                      child: _MeetDetailsBody(
                        meet: meet,
                        context: context,
                        state: state,
                        ticket: ticket,
                        meetId: meetId,
                      ),
                    ),
                  );
          }
        },
      ),
    );
  }
}

class _UserList extends HookWidget {
  const _UserList({required this.checkBilling});

  final bool checkBilling;

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
                children: [
                  Row(
                    children: [
                      Text(
                        StringConstants().soldTickets,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  10.ph,
                  Builder(
                    builder: (_) {
                      final int paidUsersCount = state.users
                          .where((user) => user.hasPaid ?? false)
                          .length;
                      return Text(
                        '$paidUsersCount ${StringConstants().ticket}${paidUsersCount > 1 ? 's' : ''} ${StringConstants().bought}${paidUsersCount > 1 ? 's' : ''} - ${state.users.length - paidUsersCount} ${StringConstants().participant}${state.users.length > 1 ? 's' : ''} ${StringConstants().pending}',
                        textAlign: TextAlign.left,
                      );
                    },
                  ),
                  10.ph,
                  ...List.generate(
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
                      return Column(
                        children: [
                          _UserCardPaymentStatus(
                            user: state.users[index],
                            checkBilling: checkBilling,
                          ),
                          10.ph,
                        ],
                      );
                    },
                  ),
                ],
              );
      },
    );
  }
}

class _UserCardPaymentStatus extends StatelessWidget {
  const _UserCardPaymentStatus({
    required this.user,
    required this.checkBilling,
  });

  final Profile user;
  final bool checkBilling;

  @override
  Widget build(BuildContext context) {
    final UploadFile? avatar = user.avatar;
    return Stack(
      children: [
        CustomCard(
          borderColor: Theme.of(context).colorScheme.tertiary,
          content: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                if (avatar == null)
                  const CircleAvatar(
                    radius: 40,
                    child: Icon(Icons.person_2_outlined),
                  )
                else
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      avatar.url,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.firstname ?? '',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      '@${user.username}',
                    ),
                  ],
                ),
                const Spacer(),
                if (checkBilling)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        StringConstants().status,
                        textAlign: TextAlign.left,
                      ),
                      5.ph,
                      Container(
                        height: 25,
                        width: 110,
                        decoration: BoxDecoration(
                          color: user.hasPaid ?? false
                              ? const Color(0xFF86FB86)
                              : Theme.of(context).colorScheme.tertiary,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Center(
                          child: Text(
                            user.hasPaid ?? false
                                ? StringConstants().boughTicket
                                : StringConstants().pending,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
        if (context.read<AuthBloc>().state.user?.id ==
                context.read<MeetDetailsBloc>().state.meet?.createdBy.id &&
            user.id != context.read<AuthBloc>().state.user?.id)
          Positioned(
            right: 0,
            child: SizedBox(
              height: 30,
              width: 30,
              child: IconButton(
                onPressed: () async {
                  confirmationPopUp(
                    context,
                    title: StringConstants().sureToKickUser,
                  ).then((choice) {
                    final int? meetId =
                        context.read<MeetDetailsBloc>().state.meet?.id;
                    if (choice && meetId != null) {
                      context.read<MeetDetailsBloc>().add(
                            KickUser(
                              userId: user.id,
                              meetId: meetId,
                            ),
                          );
                    }
                  });
                },
                icon: const Icon(
                  Icons.delete,
                  size: 15,
                ),
              ),
            ),
          ),
      ],
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

class _MeetDetailsBody extends HookWidget {
  const _MeetDetailsBody({
    required this.meet,
    required this.context,
    required this.state,
    required this.ticket,
    required this.meetId,
  });

  final Meet meet;
  final BuildContext context;
  final MeetDetailsState state;
  final Ticket? ticket;
  final int meetId;

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    final Ticket? tmpTicket = ticket;
    return ListView(
      controller: scrollController,
      children: [
        _buildHeader(context),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            children: [
              _buildMeetInfos(),
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
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        Theme.of(context).colorScheme.tertiary,
                      ),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    onPressed: () {
                      scrollController.animateTo(
                        scrollController.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 1500),
                        curve: Curves.ease,
                      );
                    },
                    child: Row(
                      children: [
                        Text(
                          StringConstants().iParticipate,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        10.pw,
                        Transform.rotate(
                          angle: -90 * (3.141592653589793 / 180),
                          child: Icon(
                            Icons.chevron_left,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
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
        if (tmpTicket != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: _TicketCardToBuy(
              ticket: tmpTicket,
              meetId: meetId,
            ),
          )
        else
          TicketTabView(
            tickets: state.ticketsToBuy,
          ),
        15.ph,
        _buildBlueBandana(state, context),
        15.ph,
        _buildChatCard(),
        25.ph,
        _buildExitButton(context, state),
        10.ph,
      ],
    );
  }

  Column _buildMeetInfos() {
    return Column(
      children: [
        15.ph,
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
      ],
    );
  }

  Stack _buildHeader(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 200,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: Image.asset(
                fit: BoxFit.cover,
                'assets/images/paris_by_night.png',
              ).image,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.close),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 20,
          child: Container(
            height: 35,
            width: 100,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(5),
                topLeft: Radius.circular(5),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.calendar_month_outlined,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                10.pw,
                Text(
                  DateTimeService.formatNbDayMonth(meet.date),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Container _buildBlueBandana(MeetDetailsState state, BuildContext context) {
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
          if (ticket != null)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      TextSpan(text: '${StringConstants().already} '),
                      TextSpan(
                        text: '${userThatPaid.length} ',
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      TextSpan(
                        text:
                            '${StringConstants().place}${userThatPaid.length > 1 ? 's' : ''} ',
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      TextSpan(
                        text:
                            '${StringConstants().sold}${userThatPaid.length > 1 ? 's' : ''}',
                      ),
                    ],
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
          _buildSoldDetails(context),
        ],
      ),
    );
  }

  ElevatedButton _buildSoldDetails(BuildContext context) {
    return ElevatedButton(
      onPressed: () => showDialog(
        context: context,
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: context.read<MeetDetailsBloc>(),
            ),
            BlocProvider.value(
              value: context.read<AuthBloc>(),
            ),
          ],
          child: Dialog(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: _UserList(
                  checkBilling:
                      context.read<MeetDetailsBloc>().state.meet?.ticket !=
                          null,
                ),
              ),
            ),
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

  Padding _buildChatCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: SizedBox(
        height: 150,
        width: double.infinity,
        child: Stack(
          children: [
            Column(
              children: [
                25.ph,
                CustomCard(
                  height: 125,
                  borderColor: Theme.of(context).colorScheme.tertiary,
                  content: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            'assets/images/paris_by_night.png',
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: AutoSizeText(
                                context
                                        .read<MeetDetailsBloc>()
                                        .state
                                        .meet
                                        ?.title ??
                                    '',
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w900,
                                ),
                                maxLines: 2,
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  height: 10,
                                  width: 10,
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                5.pw,
                                Text(
                                  '${meet.usersCount} ${StringConstants().participant}${(meet.usersCount ?? 0) > 1 ? 's' : ''}',
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                        SizedBox(
                          height: 30,
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                Theme.of(context).colorScheme.primary,
                              ),
                              shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              padding: WidgetStateProperty.all(
                                const EdgeInsets.all(5),
                              ),
                              minimumSize:
                                  WidgetStateProperty.all(const Size(0, 30)),
                            ),
                            child: AutoSizeText(
                              StringConstants().joinChat,
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              minFontSize: 8,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              right: 30,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Image.asset(
                  'assets/images/chat_bubbles.png',
                  width: 45,
                  height: 45,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
