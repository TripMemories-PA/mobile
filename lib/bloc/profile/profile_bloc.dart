import 'package:flutter_bloc/flutter_bloc.dart';

import '../../object/profile/profile.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<GetProfileEvent, ProfileState> {
  ProfileBloc() : super(const ProfileState()) {
    on<GetProfileEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
