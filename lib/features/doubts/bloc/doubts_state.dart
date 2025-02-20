part of 'doubts_bloc.dart';

sealed class DoubtsState {}

abstract class DoubtsActionState extends DoubtsState{}

final class DoubtsInitial extends DoubtsState{}

class DoubtsFetchingState extends DoubtsState{}

class DoubtsLoadedSuccessState extends DoubtsState{
  final List<dynamic> tagsList;
  final List<Map<String,dynamic>> doubtsList;
  DoubtsLoadedSuccessState({
    required this.tagsList,
    required this.doubtsList
  });
}

class ErrorLoadingState extends DoubtsState{}

