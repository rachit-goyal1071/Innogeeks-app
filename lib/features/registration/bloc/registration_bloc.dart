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
    on<PaymentSuccessfulEvent>(paymentSuccessfulEvent);
  }

  FutureOr<void> initialRegistrationEvent(InitialRegistrationEvent event, Emitter<RegistrationState> emit) async{
    emit(RegistrationFetchingState());
    final data = await ProfileRepo.getProfileDetails();
    if(await RegistrationRepo.checkUserRegistrationStatus()){
      final regData = await RegistrationRepo.getRegistrationDetails();
      final feeAmount = await RegistrationRepo.getFeeAmount();
      if(regData.isNotEmpty && feeAmount.isNotEmpty){
        emit(RegisteredCandidateFeePaymentState(data: data,feeAmount: feeAmount));
      }
    }
    else if(data.isEmpty){
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
      final data = await RegistrationRepo.getRegistrationDetails();
      final feeAmount = await RegistrationRepo.getFeeAmount();
      if(data.isNotEmpty && feeAmount.isNotEmpty){
        emit(RegisteredCandidateFeePaymentState(data: data,feeAmount: feeAmount));
      }
    } else {
      emit(RegistrationFetchingState());//requires handling as it should show wait until there is any confirmation from coordinator side
    }
  }

  FutureOr<void> paymentSuccessfulEvent(PaymentSuccessfulEvent event, Emitter<RegistrationState> emit) async{
    await RegistrationRepo.completePaymentStatus();
    emit(NewCandidateRegisteredState());
  }
}
