import 'package:flutter_bloc/flutter_bloc.dart';

import '../../object/conversation/conversation.dart';
import '../../object/message/message.dart';
import '../../object/profile/profile.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(const ChatState()) {
    on<GetConversationEvent>((event, emit) {
      final List<Message> messages = [message];
      for (int i = 0; i < 10; i++) {
        messages.add(message);
        messages.add(myMessage);
      }
      messages.add(otherMessage);
      messages.add(otherMessage2);
      final List<Message> sortedMessages = List.from(messages);
      sortedMessages.sort((a, b) => b.sentAt.compareTo(a.sentAt));
      emit(
        state.copyWith(
          conversation: Conversation(
            id: 1,
            users: const [profile, profile],
            messages: sortedMessages,
          ),
        ),
      );
    });
  }
}

const Profile me = Profile(
  isFriend: true,
  id: 1,
  username: 'johndoe',
  firstname: 'John',
  lastname: 'Doe',
  email: 'test@mail.com',
  hasSentFriendRequest: false,
  hasReceivedFriendRequest: false,
  poisCount: 0,
);

const Profile profile = Profile(
  isFriend: true,
  id: 2,
  username: 'johndoe',
  firstname: 'John',
  lastname: 'Doe',
  email: 'test@mail.com',
  hasSentFriendRequest: false,
  hasReceivedFriendRequest: false,
  poisCount: 0,
);

final Message message = Message(
  id: 2,
  message:
      'Other message edrse neiurvn eurnepu e u pevqp npu hpzue qzpmun zpqu eijbf bmefn zj',
  sender: profile,
  receiver: me,
  sentAt: DateTime.now(),
);

final Message myMessage = Message(
  id: 1,
  message:
      'My message rmopgijergijzrpigpoo gj erpoon eepiu vie e  irpaiirn ilorb riub e bvqb q olhfvbahb eh ve pmzh apmiujfnijb ',
  sender: me,
  receiver: profile,
  sentAt: DateTime.now(),
);

final Message otherMessage = Message(
  id: 1,
  message:
      'My message rmopgijergijzrpigpoo gj erpoon eepiu vie e  irpaiirn ilorb riub e bvqb q olhfvbahb eh ve pmzh apmiujfnijb ',
  sender: me,
  receiver: profile,
  sentAt: DateTime.utc(1969, 7, 20, 20, 18, 04),
);

final Message otherMessage2 = Message(
  id: 1,
  message:
      'My message rmopgijergijzrpigpoo gj erpoon eepiu vie e  irpaiirn ilorb riub e bvqb q olhfvbahb eh ve pmzh apmiujfnijb ',
  sender: me,
  receiver: profile,
  sentAt: DateTime.utc(1970, 7, 20, 20, 18, 04),
);
