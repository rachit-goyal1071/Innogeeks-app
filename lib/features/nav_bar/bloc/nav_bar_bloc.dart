import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'nav_bar_event.dart';
part 'nav_bar_state.dart';

class NavBarBloc extends Bloc<NavBarEvent, NavBarState> {
  NavBarBloc() : super(NavBarInitial()) {
    on<NavBarEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
