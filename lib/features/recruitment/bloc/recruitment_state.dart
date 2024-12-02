part of 'recruitment_bloc.dart';

@immutable
sealed class RecruitmentState {}

abstract class RecruitmentActionState extends RecruitmentState{}

final class RecruitmentInitial extends RecruitmentState {}

class RecruitmentFetchingState extends RecruitmentState{}

class RecruitmentErrorState extends RecruitmentState{}

class RecruitmentLoadedSuccessState extends RecruitmentState{
  final List<StudentDataModel> dataUserDetailsList;
  final List<String> dataIdList;
  RecruitmentLoadedSuccessState({
    required this.dataUserDetailsList,
    required this.dataIdList
});
}
