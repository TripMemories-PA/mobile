part of 'chat_bloc.dart';

class ChatState {
  const ChatState({
    this.conversation,
  });

  ChatState copyWith({
    Conversation? conversation,
  }) {
    return ChatState(
      conversation: conversation ?? this.conversation,
    );
  }

  final Conversation? conversation;
}
