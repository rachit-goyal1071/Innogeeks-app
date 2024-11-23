import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:innogeeks_app/features/profile/repo/profile_repo.dart';
import 'package:innogeeks_app/features/registration/repo/registration_repo.dart';

part 'registration_event.dart';
part 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  RegistrationBloc() : super(RegistrationInitial()) {
    on<InitialRegistrationEvent>(initialRegistrationEvent);
    on<CandidateRegisteredEvent>(candidateRegisteredEvent);
    on<MoveToCandidateFeePaymentPage>(moveToCandidateFeePaymentPage);
  }

  FutureOr<void> initialRegistrationEvent(InitialRegistrationEvent event, Emitter<RegistrationState> emit) async{
    emit(RegistrationFetchingState());
    final data = await ProfileRepo.getProfileDetails();
    if(data.isEmpty){
      emit(RegistrationErrorState());
    }else{
      emit(RegistrationLoadedSuccessState(data: data));
    }
  }

  FutureOr<void> candidateRegisteredEvent(CandidateRegisteredEvent event, Emitter<RegistrationState> emit) async{
    emit(NewCandidateRegisteredState());
  }

  FutureOr<void> moveToCandidateFeePaymentPage(MoveToCandidateFeePaymentPage event, Emitter<RegistrationState> emit) async{
    if(await RegistrationRepo.checkUserRegistrationStatus()){
      emit(RegisteredCandidateFeePaymentState());
    } else {
      emit(RegistrationFetchingState());
    }
  }
}
