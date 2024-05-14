part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

class AuthInitialState extends AuthState{}

class AuthLoadingState extends AuthState{}

class AuthLoggedInState extends AuthState{
  final User firebaseUser;
  AuthLoggedInState(this.firebaseUser);
}

class AuthCodeVerifiedState extends AuthState{}

class AuthCodeSentState extends AuthState{}

class AuthLoggedOutState extends AuthState{}

class AuthErrorState extends AuthState{
  final String error;
  AuthErrorState(this.error);
}

class AuthCheckingState extends AuthState {}

class UserDoesNotExistState extends AuthState {}

class UserAlreadyExistState extends AuthState {}

