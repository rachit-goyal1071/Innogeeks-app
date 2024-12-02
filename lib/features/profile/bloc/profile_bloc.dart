import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:innogeeks_app/features/profile/repo/profile_repo.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<ProfileInitialEvent>(profileInitialEvent);
  }

  FutureOr<void> profileInitialEvent(ProfileInitialEvent event, Emitter<ProfileState> emit) async{
    emit(ProfilePageFetchingState());
    final data = await ProfileRepo.getProfileDetails();
    if(data.isNotEmpty){
      emit(ProfileLoadedSuccessState(data: data));
    }
  }
}
