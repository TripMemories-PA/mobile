import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc/auth_bloc.dart';
import '../bloc/chat/chat_bloc.dart';
import '../component/profile_picture.dart';
import '../constants/my_colors.dart';
import '../num_extensions.dart';
import '../object/profile/profile.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key, required this.user});

  final Profile user;

  @override
  Widget build(BuildContext context) {
    final int myId = context.read<AuthBloc>().state.user?.id ?? 0;
    return SafeArea(
      child: Scaffold(
        body: BlocProvider(
          create: (context) => ChatBloc()
            ..add(
              GetConversationEvent(
                isRefresh: true,
                conversationId: 1,
              ),
            ),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                10.ph,
                _buildHeader(),
                Expanded(
                  child: BlocBuilder<ChatBloc, ChatState>(
                    builder: (context, state) {
                      return Container(
                        alignment: Alignment.bottomCenter,
                        child: _buildChatMessages(state, myId, context),
                      );
                    },
                  ),
                ),
                _buildMessageTextInput(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding _buildMessageTextInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Ecrire un message',
                  hintStyle: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Column _buildHeader() {
    return Column(
      children: [
        ProfilePicture(
          uploadedFile: user.avatar,
        ),
        10.ph,
        Text(
          '${user.firstname} ${user.lastname}',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '@${user.username}',
          style: const TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            color: MyColors.darkGrey,
            height: 1,
          ),
        ),
      ],
    );
  }

  ListView _buildChatMessages(ChatState state, int myId, BuildContext context) {
    return ListView(
      reverse: true,
      children: [
        for (int i = 0;
            i < (state.conversation?.messages.length ?? 0);
            i++) ...[
          if (i > 0 &&
              !_isSameDay(
                state.conversation?.messages[i - 1].sentAt,
                state.conversation?.messages[i].sentAt,
              ))
            _buildDaySeparator(context, state.conversation?.messages[i].sentAt),
          Row(
            mainAxisAlignment: state.conversation?.messages[i].sender.id != myId
                ? MainAxisAlignment.start
                : MainAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment:
                    state.conversation?.messages[i].sender.id != myId
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.end,
                children: [
                  _buildMessage(context, state.conversation?.messages[i], myId),
                  Align(
                    alignment: state.conversation?.messages[i].sender.id != myId
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Text(
                        _formatDate(state.conversation!.messages[i].sentAt),
                        textAlign:
                            state.conversation?.messages[i].sender.id != myId
                                ? TextAlign.left
                                : TextAlign.right,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ],
    );
  }

  bool _isSameDay(DateTime? date1, DateTime? date2) {
    if (date1 == null || date2 == null) return false;
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Widget _buildDaySeparator(BuildContext context, DateTime? date) {
    if (date == null) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            color: Theme.of(context).colorScheme.onSurface,
            width: MediaQuery.of(context).size.width * 0.3,
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              _formatDate(date),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            color: Theme.of(context).colorScheme.onSurface,
            width: MediaQuery.of(context).size.width * 0.3,
            height: 1,
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  Container _buildMessage(BuildContext context, message, int myId) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: message.sender.id != myId
            ? Theme.of(context).colorScheme.secondary
            : Theme.of(context).colorScheme.tertiary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
            message.sender.id != myId ? 0 : 10,
          ),
          topRight: Radius.circular(
            message.sender.id != myId ? 10 : 0,
          ),
          bottomRight: const Radius.circular(10),
          bottomLeft: const Radius.circular(10),
        ),
      ),
      child: Text(
        message.message,
        style: TextStyle(
          color: message.sender.id != myId
              ? Theme.of(context).colorScheme.onSecondary
              : Theme.of(context).colorScheme.onTertiary,
        ),
      ),
    );
  }
}
