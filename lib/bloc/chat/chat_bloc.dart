import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/chat/i_chat_service.dart';
import '../../api/error/api_error.dart';
import '../../api/exception/custom_exception.dart';
import '../../api/pusher_service.dart';
import '../../dto/conversation/conversation_dto.dart';
import '../../object/conversation.dart';
import '../../object/message.dart';
import '../../object/meta_object.dart';
import '../../repository/chat/i_chat_repository.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc({
    required this.chatRepository,
    required this.chatService,
  }) : super(
          ChatState(
            conversation: Conversation(
              meta: MetaObject.initial(),
              messages: [],
            ),
          ),
        ) {
    on<GetConversationEvent>((event, emit) async {
      event.isRefresh
          ? emit(state.copyWith(conversationStatus: ConversationStatus.loading))
          : emit(
              state.copyWith(
                loadMoreMessageStatus: ConversationStatus.loading,
              ),
            );
      try {
        final Future<Conversation> Function() getConversationMessages =
            event.type == ConversationType.meet
                ? () => chatRepository.getMeetConversationMessages(
                      meetId: event.userId,
                      page: event.isRefresh ? 1 : state.currentPage + 1,
                      perPage: state.perPage,
                    )
                : () => chatRepository.getPrivateConversationMessages(
                      userId: event.userId,
                      page: event.isRefresh ? 1 : state.currentPage + 1,
                      perPage: state.perPage,
                    );

        final Conversation conversation = await getConversationMessages();
        if (event.isRefresh) {
          emit(
            state.copyWith(
              conversation: conversation,
              conversationStatus: ConversationStatus.initial,
              currentPage: 1,
              hasMoreMessage:
                  conversation.messages.length != conversation.meta.total,
            ),
          );
        } else {
          final List<Message> newMessages = state.conversation.messages;
          final List<Message> updatedConversation = [
            ...state.conversation.messages,
            ...conversation.messages,
          ];
          emit(
            state.copyWith(
              conversation:
                  conversation.copyWith(messages: updatedConversation),
              currentPage: state.currentPage + 1,
              hasMoreMessage: newMessages.length != conversation.meta.total,
              loadMoreMessageStatus: ConversationStatus.initial,
            ),
          );
        }
      } catch (e) {
        emit(
          state.copyWith(
            error: e is CustomException ? e.apiError : ApiError.unknown(),
          ),
        );
      }
      emit(
        state.copyWith(
          conversationStatus: ConversationStatus.initial,
          loadMoreMessageStatus: ConversationStatus.initial,
        ),
      );
    });

    on<PusherConnectEvent>((event, emit) async {
      emit(state.copyWith(conversationStatus: ConversationStatus.loading));
      try {
        final publicChannel = PusherService.getInstance()
            .pusherInstance
            .publicChannel(event.channelName);

        await PusherService.getInstance().pusherInstance.connect();
        publicChannel.subscribe();

        emit(
          state.copyWith(
            conversationStatus: ConversationStatus.initial,
            stream: publicChannel.bindToAll().listen(
              (event) async {
                try {
                  final Map<String, dynamic>? message = event.tryGetDataAsMap();
                  if (message == null) {
                    return;
                  }
                  final Message newMessage = Message.fromJson(message);
                  add(NewMessageEvent(newMessage));
                } catch (e) {
                  if (!emit.isDone) {
                    emit(
                      state.copyWith(
                        error: ApiError.errorOccurredWhileParsingResponse(),
                      ),
                    );
                  }
                }
              },
            ),
          ),
        );
      } catch (e) {
        emit(state.copyWith(error: ApiError('Connection error: $e')));
      }
    });

    on<NewMessageEvent>((event, emit) {
      final List<Message> updatedMessages = [
        event.message,
        ...state.conversation.messages,
      ];
      emit(
        state.copyWith(
          conversation: state.conversation.copyWith(messages: updatedMessages),
          newMessageReceived: true,
        ),
      );
    });

    on<PostMessageEvent>((event, emit) async {
      try {
        emit(
          state.copyWith(
            sendingMessageStatus: ConversationStatus.loading,
          ),
        );
        event.conversationType == ConversationType.meet
            ? await chatService.postMeetMessage(
                meetId: event.userId,
                content: event.content,
              )
            : await chatService.postPrivateMessage(
                userId: event.userId,
                content: event.content,
              );
      } catch (e) {
        emit(
          state.copyWith(
            error: e is CustomException ? e.apiError : ApiError.unknown(),
          ),
        );
      }
      emit(
        state.copyWith(
          sendingMessageStatus: ConversationStatus.initial,
        ),
      );
    });
  }

  final IChatRepository chatRepository;
  final IChatService chatService;

  @override
  Future<void> close() async {
    PusherService.getInstance().pusherInstance.disconnect();
    state.stream?.cancel();
    return super.close();
  }
}
