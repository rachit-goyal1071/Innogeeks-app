part of 'profile_bloc.dart';

sealed class ProfileState {}

abstract class ProfileActionState extends ProfileState{}

final class ProfileInitial extends ProfileState {}

class ProfilePageFetchingState extends ProfileState{}

class ProfileLoadedSuccessState extends ProfileState{
  final Map<String,dynamic> data;
  ProfileLoadedSuccessState({
    required this.data
  });
}
