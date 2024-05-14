// ignore_for_file: use_build_context_synchronously

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:innogeeks_app/features/auth/services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthCubit() : super(AuthInitialState()) {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      emit(AuthLoggedInState(currentUser));
    }
    else {
      emit(AuthLoggedOutState());
    }
  }

  String? _verificationId;

  void sendOtp(String phoneNumber, BuildContext context) async {
    emit(AuthLoadingState());
    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        codeSent: (verificationId, forceResendingToken) {
          _verificationId = verificationId;
          emit(AuthCodeSentState());
        },
        verificationCompleted: (phoneAuthCredential) {
          if (kDebugMode) {
            print(phoneAuthCredential);
          }
        },
        verificationFailed: (errorMessage) {
          emit(AuthErrorState(errorMessage.message.toString()));
        },
        codeAutoRetrievalTimeout: (verificationId) {
          _verificationId = verificationId;
        });
  }

  void verifyOtp(String otp, BuildContext context) {
    emit(AuthLoadingState());
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp);
    signInWIthPhone(credential, context);
  }


  void signInWIthPhone(PhoneAuthCredential credential,
      BuildContext context) async {
    try {
      UserCredential userCredential =
        await _auth.signInWithCredential(credential);
      if(userCredential.user != null){
        emit(AuthLoggedInState(userCredential.user!));
        Navigator.push(context, MaterialPageRoute(builder: (context)=> const SizedBox())); // change to user page
      }
      else{

      }
    }on FirebaseAuthException catch (e) {
      emit(AuthErrorState(e.message.toString()));
    }
  }

  void logOut() async{
    await _auth.signOut();
    emit(AuthLoggedOutState());
  }

  void checkUserExistence() async{
    emit(AuthCheckingState());

    final doesUserExist = await AuthServices().doesUserExist(_auth.currentUser!.uid);
    if(doesUserExist){
      emit(UserAlreadyExistState());
    }else{
      emit(UserDoesNotExistState());
    }
  }
}
