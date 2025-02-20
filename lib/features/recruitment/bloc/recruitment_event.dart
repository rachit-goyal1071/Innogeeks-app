part of 'recruitment_bloc.dart';

sealed class RecruitmentEvent {}

class RecruitmentInitialEvent extends RecruitmentEvent{}

class RecruitmentSortingEvent extends RecruitmentEvent{
  final List<StudentDataModel> dataModel;
  final String sortBy;
  final List<String> dataIdList;
  RecruitmentSortingEvent({
    required this.dataModel,
    required this.sortBy,
    required this.dataIdList
  });
}
