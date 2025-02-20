part of 'registration_bloc.dart';

sealed class RegistrationState {}

abstract class RegistrationActionState extends RegistrationState{}

final class RegistrationInitial extends RegistrationState {}

class RegistrationFetchingState extends RegistrationState{}

class RegistrationErrorState extends RegistrationState{}

class RegistrationLoadedSuccessState extends RegistrationState{
  final Map<String,dynamic> data;
  RegistrationLoadedSuccessState({
    required this.data
  });
}

class NewCandidateRegisteredState extends RegistrationActionState{}

class RegisteredCandidateFeePaymentState extends RegistrationState{
  final Map<String,dynamic> data;
  final String feeAmount;
  RegisteredCandidateFeePaymentState({
    required this.data,
    required this.feeAmount
  });
}