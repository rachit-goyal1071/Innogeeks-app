import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innogeeks_app/features/auth/bloc/auth_cubit.dart';
import 'package:lottie/lottie.dart';

class AuthLoadingPage extends StatefulWidget {
  const AuthLoadingPage({super.key});

  @override
  State<AuthLoadingPage> createState() => _AuthLoadingPageState();
}

class _AuthLoadingPageState extends State<AuthLoadingPage> {

  final AuthCubit authCubit = AuthCubit();

  @override
  void initState(){
    authCubit.checkUserExistence();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
        bloc: authCubit,
        listener: (context,state){
          if(state is AuthCodeVerifiedState){
            // Navigate to userDetailsPage when OTP is verified
            // Navigator.pushReplacementNamed(context, 'userDetailsPage');
            Navigator.push(context, MaterialPageRoute(builder: (context)=> const SizedBox())); // to user details page(On boarding)
          } else if(state is UserDoesNotExistState){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> const SizedBox())); // to user details page(On boarding)
          }else if(state is UserAlreadyExistState){
            Navigator.pushReplacementNamed(context, ''); //Route to the home page
          }
        },
        builder: (context, state){
          switch (state.runtimeType){
            case AuthLoadingState :
              return Scaffold(
                body: Center(
                  child: Lottie.asset('assets/svgs/auth_loading_animation.json'),
                ),
              );
            default:
              return const Scaffold();
          }
        },
    );
  }
}
