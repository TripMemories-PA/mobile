import '../../object/profile.dart';
import 'conversation_dto.dart';

class PrivateConversationDto extends ConversationDto {
  PrivateConversationDto({
    required super.id,
    required super.channel,
    super.conversationType = ConversationType.private,
    required this.user,
  });

  final Profile user;
}
