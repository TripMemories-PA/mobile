part of 'chat_bloc.dart';

sealed class ChatEvent {}

class GetConversationEvent extends ChatEvent {
  GetConversationEvent({
    required this.isRefresh,
    required this.conversationId,
  });

  final bool isRefresh;
  final int conversationId;
}
