part of 'registration_bloc.dart';

sealed class RegistrationEvent {}

class InitialRegistrationEvent extends RegistrationEvent{}

class CandidateRegisteredEvent extends RegistrationEvent{}

class MoveToCandidateFeePaymentPage extends RegistrationEvent{}

class PaymentSuccessfulEvent extends RegistrationEvent{}