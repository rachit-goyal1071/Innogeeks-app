import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:innogeeks_app/constants/colors.dart';
import 'package:innogeeks_app/features/auth/bloc/auth_cubit.dart';
import 'package:innogeeks_app/features/auth/ui/verify_otp_page.dart';
import '../../../constants/dimensions.dart';

class SignInPage extends StatelessWidget {
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/innos_logo.png',
                  height: MediaQuery.of(context).size.height * 0.45,
                  width: MediaQuery.of(context).size.width *0.8,
                  fit: BoxFit.cover,
                  alignment: Alignment.centerLeft,
                ),
                const SizedBox(height: 20,),
                Text(
                  'ONLY GEEKS',
                  style: GoogleFonts.sourceSans3(
                    color: Colors.black,
                    fontSize: getScreenHeight(context)*0.054,
                    fontWeight: FontWeight.w700,
                  ),),
                const SizedBox(height: 20),
                const Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Log In or Sign Up',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left:19,right:19),
                  child: TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone, // Set keyboard type for phone numbers
                    decoration: InputDecoration(
                      labelText: 'Phone Number', // Optional label text
                      prefixText: '+91', // Prefill with "+91" for India country code
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0), // Adjust border radius as needed
                        borderSide: const BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder( // Optional styling for focused state
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Colors.blue, // Change color for focus (optional)
                        ),
                      ),
                    ),
                    // Add input formatter for phone number formatting (optional)
                    inputFormatters: [
                      // You can add a custom formatter for specific phone number format
                      FilteringTextInputFormatter.digitsOnly, // Allow only digits
                    ],
                  ),
                ),
                const SizedBox(height: 20,),
                BlocConsumer<AuthCubit,AuthState>(
                  listener: (context,state){
                    if(state is AuthCodeSentState){
                      Navigator.push(context, CupertinoPageRoute(builder: (context)=> VerifyOtpPage(gotNumber: phoneController.text)));
                    }else if(state is AuthErrorState){
                      if (kDebugMode) {
                        print(state.error);
                      }
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
                        child: Image.asset('assets/gif/loader_1.gif',color: primaryInnoColor,)
                      );
                    }
                    return SizedBox(
                      width: getScreenWidth(context)*0.7,
                      child: ElevatedButton(
                        onPressed: (){
                          String phoneNumber = '+91${phoneController.text}';
                          BlocProvider.of<AuthCubit>(context).sendOtp(phoneNumber, context);
                        },
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, backgroundColor: const Color.fromARGB(255, 255, 111, 0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                          ),
                        ),
                        child: const Text('Continue'),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
