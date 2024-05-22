part of 'nav_bar_bloc.dart';

@immutable
sealed class NavBarEvent {}

class TabChangeEvent extends NavBarEvent{
  final int tabIndex;
  TabChangeEvent({
    required this.tabIndex
  });
}