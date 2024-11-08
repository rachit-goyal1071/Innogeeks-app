import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innogeeks_app/features/auth/bloc/auth_cubit.dart';
import 'package:innogeeks_app/features/auth/ui/auth_loading_page.dart';
import 'package:innogeeks_app/features/auth/ui/user_details_page.dart';
import 'package:innogeeks_app/features/nav_bar/ui/nav_bar.dart';
import 'package:lottie/lottie.dart';

class VerifyOtpPage extends StatefulWidget {
  final String gotNumber;
  const VerifyOtpPage({super.key, required this.gotNumber});

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {

  AuthCubit authCubit = AuthCubit();

  TextEditingController otpController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var newString = widget.gotNumber.substring(widget.gotNumber.length -4);
    if (kDebugMode) {
      print(newString);
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Login with OTP',
            style: TextStyle(fontWeight: FontWeight.bold)),
        leading: const BackButton(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              const Text('To confirm the Phone no. Please',
                style: TextStyle(
                  fontSize: 20
                ),
              ),
              const Text('enter the otp we sent to',
                style: TextStyle(
                    fontSize: 20
                ),
              ),
              const SizedBox(height: 15),
              Text(
                '+91 XXXXXX$newString',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20,),
              Padding(
                  padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextField(
                    controller: otpController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText:
                      'XXX XXX',
                      hintStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                      counterText: '',
                    ),
                    maxLength: 6,
                    obscureText: true,
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              BlocConsumer<AuthCubit,AuthState>(
                  bloc: authCubit,
                  listener: (context,state){
                    if(state is AuthLoggedInState){
                      Navigator.popUntil(context, (route) => route.isFirst);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const AuthLoadingPage()));
                    } else if(state is AuthErrorState){
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.error),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  builder: (context,state){
                    if(state is AuthLoadingState){
                      return Center(
                        child: Lottie.asset('assets/svgs/otp_loader.json'),
                      );
                    }
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                            onPressed: (){
                              BlocProvider.of<AuthCubit>(context).verifyOtp(otpController.text, context);
                            },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: const Color.fromARGB(
                                255, 251, 107, 35), backgroundColor: Colors.blue, // Text color for Login button
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  5.0), // Adjust border radius as needed
                            ),
                          ),
                            child: const Text('                Login                  ',
                                style: TextStyle(color: Colors.white)),
                        ),
                        const SizedBox(height: 10.0),
                        OutlinedButton(
                          onPressed: () {
                            BlocProvider.of<AuthCubit>(context).sendOTP(phone: '+91${widget.gotNumber}');
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color.fromARGB(255, 251, 107,
                                35), side: const BorderSide(
                            color: Colors.grey,
                          ), // Reddish orange border
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  5.0), // Adjust border radius as needed
                            ),
                          ),
                          child: const Text('Resend Verification OTP',style: TextStyle(color: Colors.black),),
                        ),
                      ],
                    );
                  }
              )
            ],
          ),
        ),
      ),
    ) ;
  }
}
