import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../api/chat/chat_service.dart';
import '../bloc/auth_bloc/auth_bloc.dart';
import '../bloc/chat/chat_bloc.dart';
import '../component/profile_picture.dart';
import '../component/text_field_custom.dart';
import '../constants/my_colors.dart';
import '../constants/string_constants.dart';
import '../dto/conversation/conversation_dto.dart';
import '../dto/conversation/meet_conversation_dto.dart';
import '../dto/conversation/private_conversation_dto.dart';
import '../num_extensions.dart';
import '../repository/chat/chat_repository.dart';
import 'meet_page.dart';

class ChatPage extends HookWidget {
  const ChatPage({super.key, required this.conversationDto});

  final ConversationDto conversationDto;

  @override
  Widget build(BuildContext context) {
    final messageController = useTextEditingController();
    return SafeArea(
      child: Scaffold(
        body: BlocProvider(
          create: (context) => ChatBloc(
            chatRepository: RepositoryProvider.of<ChatRepository>(context),
            chatService: ChatService(),
          )
            ..add(
              GetConversationEvent(
                isRefresh: true,
                userId: conversationDto.id,
                type: conversationDto.conversationType,
              ),
              // TODO(nono): faire sans le !
            )
            ..add(PusherConnectEvent(conversationDto.channel)),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                10.ph,
                if (conversationDto is PrivateConversationDto)
                  _buildPrivateConversationHeader(),
                if (conversationDto is MeetConversationDto)
                  _buildMeetConversationHeader(
                    conversationDto: conversationDto as MeetConversationDto,
                  ),
                _ChatBody(
                  conversationId: conversationDto.id,
                  conversationType: conversationDto.conversationType,
                ),
                _buildMessageTextInput(context, messageController),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding _buildMessageTextInput(
    BuildContext context,
    TextEditingController messageController,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextFieldCustom(
              controller: messageController,
              hintText: StringConstants().writeMessage,
            ),
          ),
          // IconButton(
          //   icon: const Icon(Icons.send),
          //   onPressed: () {},
          // ),
          BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              return state.sendingMessageStatus == ConversationStatus.loading
                  ? const CircularProgressIndicator()
                  : IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        if (messageController.text.isNotEmpty &&
                            state.sendingMessageStatus !=
                                ConversationStatus.loading) {
                          context.read<ChatBloc>().add(
                                PostMessageEvent(
                                  content: messageController.text,
                                  userId: conversationDto.id,
                                  conversationType:
                                      conversationDto.conversationType,
                                ),
                              );
                          messageController.clear();
                        }
                      },
                    );
            },
          ),
        ],
      ),
    );
  }

  Column _buildPrivateConversationHeader() {
    final PrivateConversationDto privateConversationDto =
        conversationDto as PrivateConversationDto;
    return Column(
      children: [
        ProfilePicture(
          uploadedFile: privateConversationDto.user.avatar,
        ),
        10.ph,
        Text(
          '${privateConversationDto.user.firstname} ${privateConversationDto.user.lastname}',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '@${privateConversationDto.user.username}',
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

  Column _buildMeetConversationHeader({
    required MeetConversationDto conversationDto,
  }) {
    return Column(
      children: [
        Text(
          conversationDto.meet.title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        10.ph,
        MeetCardPeople(
          users: conversationDto.users,
          maxUserAvatar: 10,
          avatarSize: 45,
        ),
        10.ph,
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
}

class _ChatBody extends HookWidget {
  const _ChatBody({
    required this.conversationId,
    required this.conversationType,
  });

  final int conversationId;
  final ConversationType conversationType;

  @override
  Widget build(BuildContext context) {
    final listViewController = useScrollController();
    final int myId = context.read<AuthBloc>().state.user?.id ?? 0;
    useEffect(
      () {
        void createScrollListener() {
          if (listViewController.position.pixels >=
              listViewController.position.maxScrollExtent - 100) {
            _getPreviousMessages(context);
          }
        }

        listViewController.addListener(createScrollListener);
        return () => listViewController.removeListener(createScrollListener);
      },
      const [],
    );
    return Expanded(
      child: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) async {},
        builder: (context, state) {
          return Container(
            alignment: Alignment.bottomCenter,
            child: _buildChatMessages(state, myId, context, listViewController),
          );
        },
      ),
    );
  }

  void _getPreviousMessages(BuildContext context) {
    final ChatBloc chatBloc = context.read<ChatBloc>();
    if (chatBloc.state.hasMoreMessage &&
        chatBloc.state.loadMoreMessageStatus == ConversationStatus.initial) {
      chatBloc.add(
        GetConversationEvent(
          isRefresh: false,
          userId: conversationId,
          type: conversationType,
        ),
      );
    }
  }

  BlocListener<dynamic, dynamic> _buildChatMessages(
    ChatState state,
    int myId,
    BuildContext context,
    listViewController,
  ) {
    return BlocListener<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state.newMessageReceived) {
          if (listViewController.position.atEdge) {
            if (listViewController.position.pixels != 0) {
              listViewController.animateTo(
                listViewController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          }
        }
      },
      child: ListView(
        reverse: true,
        controller: listViewController,
        children: [
          for (int i = 0; i < (state.conversation.messages.length); i++) ...[
            if (i > 0 &&
                !_isSameDay(
                  state.conversation.messages[i - 1].createdAt,
                  state.conversation.messages[i].createdAt,
                ))
              _buildDaySeparator(
                context,
                state.conversation.messages[i].createdAt,
              ),
            Row(
              mainAxisAlignment:
                  state.conversation.messages[i].sender.id != myId
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment:
                      state.conversation.messages[i].sender.id != myId
                          ? CrossAxisAlignment.start
                          : CrossAxisAlignment.end,
                  children: [
                    _buildMessage(
                      context,
                      state.conversation.messages[i],
                      myId,
                    ),
                    Align(
                      alignment:
                          state.conversation.messages[i].sender.id != myId
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Text(
                          _formatDate(state.conversation.messages[i].createdAt),
                          textAlign:
                              state.conversation.messages[i].sender.id != myId
                                  ? TextAlign.left
                                  : TextAlign.right,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
          if (state.loadMoreMessageStatus == ConversationStatus.loading &&
              state.hasMoreMessage)
            const Center(child: CupertinoActivityIndicator()),
        ],
      ),
    );
  }

  bool _isSameDay(DateTime? date1, DateTime? date2) {
    if (date1 == null || date2 == null) {
      return false;
    }
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
        message.content,
        style: TextStyle(
          color: message.sender.id != myId
              ? Theme.of(context).colorScheme.onSecondary
              : Theme.of(context).colorScheme.onTertiary,
        ),
      ),
    );
  }
}
