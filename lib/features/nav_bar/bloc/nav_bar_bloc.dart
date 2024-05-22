import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'nav_bar_event.dart';
part 'nav_bar_state.dart';

class NavBarBloc extends Bloc<NavBarEvent, NavBarState> {
  NavBarBloc() : super(NavBarInitial(tabIndex: 0)) {
    on<NavBarEvent>((event, emit) {
      on<TabChangeEvent>(tabChangeEvent);
    });
  }

  FutureOr<void> tabChangeEvent(
      TabChangeEvent event, Emitter<NavBarState> emit) {
    emit(NavBarInitial(tabIndex: event.tabIndex));
  }
}
