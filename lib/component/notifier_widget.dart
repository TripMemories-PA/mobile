import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';

import '../bloc/notifier_bloc/notifier_bloc.dart';
import '../bloc/notifier_bloc/notifier_state.dart';

class NotifierWidget extends StatelessWidget {
  const NotifierWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotifierBloc, NotifierState>(
      listener: (context, state) {
        toastification.show(
          context: context,
          title: Text(state.content ?? ''),
          autoCloseDuration: const Duration(seconds: 3),
          type: state.notificationType?.type ?? ToastificationType.info,
          style: state.notificationType?.style,
        );
      },
      child: const SizedBox.shrink(),
    );
  }
}
