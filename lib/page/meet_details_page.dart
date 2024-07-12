import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../bloc/meet_details/meet_details_bloc.dart';
import '../object/meet.dart';
import '../repository/meet/meet_repository.dart';

class MeetDetailsPage extends StatelessWidget {
  const MeetDetailsPage({super.key, required this.meetId});

  final int meetId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MeetDetailsBloc(
        meetRepository: RepositoryProvider.of<MeetRepository>(
          context,
        ),
      )..add(
          GetMeet(
            meetId: meetId,
          ),
        ),
      child: BlocBuilder<MeetDetailsBloc, MeetDetailsState>(
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
                      ],
                    ),
                  );
          }
        },
      ),
    );
  }
}
