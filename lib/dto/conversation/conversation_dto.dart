enum ConversationType { private, meet }

abstract class ConversationDto {
  ConversationDto({
    required this.id,
    required this.channel,
    required this.conversationType,
  });

  final int id;
  final String channel;
  final ConversationType conversationType;
}
