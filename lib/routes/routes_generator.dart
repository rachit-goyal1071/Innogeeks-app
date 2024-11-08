import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innogeeks_app/features/auth/bloc/auth_cubit.dart';
import 'package:innogeeks_app/features/auth/ui/auth_loading_page.dart';
import 'package:innogeeks_app/features/nav_bar/bloc/nav_bar_bloc.dart';
import 'package:innogeeks_app/features/nav_bar/ui/nav_bar.dart';

class RouteGenerator {
  final NavBarBloc navBarBloc = NavBarBloc();
  final AuthCubit authCubit = AuthCubit();
  Route<dynamic> generateRoute(RouteSettings routeSettings){
    switch (routeSettings.name){
      case '/':
        return MaterialPageRoute(
            builder: (_)=> BlocProvider<NavBarBloc>.value(value: navBarBloc,child: const NavBar(),)); // Main page bloc to be added
      case 'authLoadingPage':
        return MaterialPageRoute(
            builder: (_)=> BlocProvider<AuthCubit>.value(value: authCubit,child: const AuthLoadingPage(),),
        );
      default:
        return _errorRoute();
    }
  }
  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return const Scaffold(
        body: Center(child: Text('Error')),
      );
    });
  }
}