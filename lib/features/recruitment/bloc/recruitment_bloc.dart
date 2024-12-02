import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:innogeeks_app/features/recruitment/repo/recruitment_repo.dart';
import 'package:innogeeks_app/models/student_data_model.dart';
import 'package:meta/meta.dart';

part 'recruitment_event.dart';
part 'recruitment_state.dart';

class RecruitmentBloc extends Bloc<RecruitmentEvent, RecruitmentState> {
  RecruitmentBloc() : super(RecruitmentInitial()) {
    on<RecruitmentInitialEvent>(recruitmentInitialEvent);
  }

  FutureOr<void> recruitmentInitialEvent(RecruitmentInitialEvent event, Emitter<RecruitmentState> emit) async{
    emit(RecruitmentFetchingState());
    final dataIdList = await RecruitmentRepo.recruitmentDataIdList();
    final dataUserDetailsList = await RecruitmentRepo.recruitmentDataUserDetailsList();
    if(dataIdList.isNotEmpty && dataUserDetailsList.isNotEmpty){
      emit(RecruitmentLoadedSuccessState(dataIdList: dataIdList,dataUserDetailsList: dataUserDetailsList));
    }else{
      emit(RecruitmentErrorState());
    }
  }
}
