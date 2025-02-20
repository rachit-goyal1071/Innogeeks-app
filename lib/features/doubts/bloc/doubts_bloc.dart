import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:innogeeks_app/features/doubts/repo/doubts_repo.dart';

part 'doubts_event.dart';
part 'doubts_state.dart';

class DoubtsBloc extends Bloc<DoubtsEvent, DoubtsState> {
  DoubtsBloc() : super(DoubtsInitial()) {
    on<DoubtsInitialEvent>(doubtsInitialEvent);
  }

  FutureOr<void> doubtsInitialEvent(
      DoubtsInitialEvent event,Emitter<DoubtsState> emit) async{
    emit(DoubtsFetchingState());
    List<dynamic> tagsList = (await DoubtsRepo.getTagsList())..sort();
    List<Map<String,dynamic>> doubtsList = (await DoubtsRepo.fetchDoubtsList()).reversed.toList();
    if (kDebugMode) {
      print(doubtsList);
    }
    emit(DoubtsLoadedSuccessState(tagsList: tagsList, doubtsList: doubtsList));
  }
}
