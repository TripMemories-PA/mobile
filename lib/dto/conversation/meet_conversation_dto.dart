import '../../object/meet.dart';
import '../../object/profile.dart';
import 'conversation_dto.dart';

class MeetConversationDto extends ConversationDto {
  MeetConversationDto({
    required super.id,
    required super.channel,
    super.conversationType = ConversationType.meet,
    required this.users,
    required this.meet,
  });

  final List<Profile> users;
  final Meet meet;
}
