import 'package:flutter_bloc/flutter_bloc.dart';

import '../../object/conversation/conversation.dart';
import '../../object/message/message.dart';
import '../../object/profile/profile.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(const ChatState()) {
    on<GetConversationEvent>((event, emit) {
      // TODO: implement event handler
      List<Message> messages = [message];
      for (int i = 0; i < 10; i++) {
        messages.add(message);
        messages.add(myMessage);
      }
      emit(
        state.copyWith(
          conversation: Conversation(
            id: 1,
            users: const [profile, profile],
            messages: messages,
          ),
        ),
      );
    });
  }
}

const Profile profile = Profile(
  isFriend: true,
  id: 1,
  username: 'johndoe',
  firstname: 'John',
  lastname: 'Doe',
  email: 'test@mail.com',
  isSentFriendRequest: false,
  isReceivedFriendRequest: false,
);

final Message message = Message(
  id: 2,
  message: 'Hello',
  sender: profile,
  receiver: profile,
  sentAt: DateTime.now(),
);

final Message myMessage = Message(
  id: 1,
  message: 'Hello',
  sender: profile,
  receiver: profile,
  sentAt: DateTime.now(),
);
