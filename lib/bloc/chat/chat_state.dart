part of 'chat_bloc.dart';

enum ConversationStatus { loading, initial, error }

class ChatState {
  const ChatState({
    required this.conversation,
    this.conversationStatus = ConversationStatus.initial,
    this.error,
    this.stream,
    this.currentPage = 0,
    this.perPage = 20,
    this.hasMoreMessage = true,
    this.loadMoreMessageStatus = ConversationStatus.initial,
    this.sendingMessageStatus = ConversationStatus.initial,
    this.newMessageReceived = false,
  });

  ChatState copyWith({
    Conversation? conversation,
    ConversationStatus? conversationStatus,
    ApiError? error,
    StreamSubscription? stream,
    int? currentPage,
    int? perPage,
    bool? hasMoreMessage,
    ConversationStatus? loadMoreMessageStatus,
    ConversationStatus? sendingMessageStatus,
    bool? newMessageReceived,
  }) {
    return ChatState(
      conversation: conversation ?? this.conversation,
      conversationStatus: conversationStatus ?? this.conversationStatus,
      error: error,
      stream: stream ?? this.stream,
      currentPage: currentPage ?? this.currentPage,
      perPage: perPage ?? this.perPage,
      hasMoreMessage: hasMoreMessage ?? this.hasMoreMessage,
      loadMoreMessageStatus:
          loadMoreMessageStatus ?? this.loadMoreMessageStatus,
      sendingMessageStatus: sendingMessageStatus ?? this.sendingMessageStatus,
      newMessageReceived: newMessageReceived ?? false,
    );
  }

  final Conversation conversation;
  final ConversationStatus conversationStatus;
  final ApiError? error;
  final StreamSubscription? stream;
  final int currentPage;
  final int perPage;
  final bool hasMoreMessage;
  final ConversationStatus loadMoreMessageStatus;
  final ConversationStatus sendingMessageStatus;
  final bool newMessageReceived;
}
