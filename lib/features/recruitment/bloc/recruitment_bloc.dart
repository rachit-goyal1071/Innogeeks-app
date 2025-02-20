import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:innogeeks_app/features/recruitment/repo/recruitment_repo.dart';
import 'package:innogeeks_app/models/student_data_model.dart';

part 'recruitment_event.dart';
part 'recruitment_state.dart';

class RecruitmentBloc extends Bloc<RecruitmentEvent, RecruitmentState> {
  RecruitmentBloc() : super(RecruitmentInitial()) {
    on<RecruitmentInitialEvent>(recruitmentInitialEvent);
    on<RecruitmentSortingEvent>(recruitmentSortingEvent);
  }

  FutureOr<void> recruitmentInitialEvent(RecruitmentInitialEvent event, Emitter<RecruitmentState> emit) async{
    emit(RecruitmentFetchingState());
    final dataIdList = await RecruitmentRepo.recruitmentDataIdList();
    final dataUserDetailsList = await RecruitmentRepo.recruitmentDataUserDetailsList();
    if(dataIdList.isNotEmpty && dataUserDetailsList.isNotEmpty){
      emit(RecruitmentLoadedSuccessState(dataIdList: dataIdList,dataUserDetailsList: dataUserDetailsList,isInitial: true));
    }else{
      emit(RecruitmentErrorState());
    }
  }

  FutureOr<void> recruitmentSortingEvent(RecruitmentSortingEvent event, Emitter<RecruitmentState> emit) async{
    List<StudentDataModel> filter = [];
    if(event.sortBy=='name'){
      filter = event.dataModel..sort((a,b)=>a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    }
    else if(event.sortBy=='lib'){
      filter = event.dataModel..sort((a,b)=>a.lib.substring(a.lib.length -5).compareTo(b.lib.substring(b.lib.length -5)));
    }
    else if('branch'==event.sortBy.split('/').first){
      filter = event.dataModel.where((student)=>student.branch==event.sortBy.split('/').last).toList();
    }
    emit(RecruitmentLoadedSuccessState(dataUserDetailsList: filter, dataIdList: event.dataIdList,isInitial: false));
  }
}
