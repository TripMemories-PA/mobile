import 'package:flutter_bloc/flutter_bloc.dart';

import '../../object/profile/profile.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(const ProfileState()) {
    on<GetProfileEvent>((event, emit) {
      // TODO(nono): implement event handler
    });

    on<UpdateProfileEvent>((event, emit) {
      // TODO(nono): implement event handler
    });

    on<UpdatePasswordEvent>((event, emit) {
      // TODO(nono): implement event handler
    });
  }
}
