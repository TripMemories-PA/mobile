part of 'chat_bloc.dart';

sealed class ChatEvent {}

class GetConversationEvent extends ChatEvent {
  GetConversationEvent({
    required this.isRefresh,
    required this.userId,
    required this.type,
  });

  final bool isRefresh;
  final int userId;
  final ConversationType type;
}

class PusherConnectEvent extends ChatEvent {
  PusherConnectEvent(this.channelName);

  String channelName;
}

class NewMessageEvent extends ChatEvent {
  NewMessageEvent(this.message);

  final Message message;
}

class PostMessageEvent extends ChatEvent {
  PostMessageEvent({
    required this.content,
    required this.userId,
    required this.conversationType,
  });

  final String content;
  final int userId;
  final ConversationType conversationType;
}
