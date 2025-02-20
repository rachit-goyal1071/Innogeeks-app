part of 'attendance_bloc.dart';

sealed class AttendanceState {}

abstract class AttendanceActionState extends AttendanceState{}

final class AttendanceInitial extends AttendanceState {}

class AttendanceStatusFetchingState extends AttendanceState{}

class FirstYearAttendanceData extends AttendanceState{}

class LoadedAttendanceData extends AttendanceState{}

class ErrorLoadingAttendanceData extends AttendanceState{}