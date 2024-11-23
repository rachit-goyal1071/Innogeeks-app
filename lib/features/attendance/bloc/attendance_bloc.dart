import 'dart:async';

import 'package:bloc/bloc.dart';

part 'attendance_event.dart';
part 'attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  AttendanceBloc() : super(AttendanceInitial()) {
    on<AttendanceInitialEvent>(attendanceInitialEvent);
  }

  FutureOr<void> attendanceInitialEvent(
      AttendanceInitialEvent event, Emitter<AttendanceState> emit) {
    emit(AttendanceStatusFetchingState());

  }
}
