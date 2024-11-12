// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  continueWithGoogle(BuildContext context) async{
    //Trigger authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if(googleUser != null){
      //Obtain the auth details from user
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      //create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken
      );

      // once signed in navigate to home screen
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;
      if(user != null){
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, 'authLoadingPage');
      }
      return user;
    }else{
      // handling of sign in errors
      return null;
    }
  }
  doesUserExist(String userId) async {
    final snapshot = await FirebaseFirestore.instance.collection('users').doc(
        userId).get();
    if (snapshot.exists) {
      if (snapshot.data()!.containsKey('userExiset')) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  Future<void> uploadUserData({
    required String firstName,
    required String lastName,
    required String mobileNumber,
    required String address,
    required bool hostler,
    required String email,
    required String kietEmail,
    required String libId,
    required String profileImage,
    required String domain,
  }) async {
    //get fcm token
    final firebaseMessaging = FirebaseMessaging.instance;
    final fcmToken = await firebaseMessaging.getToken();
    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).set({
      'firstName': firstName,
      'lastName': lastName,
      'mobileNumber': mobileNumber,
      'address': address,
      'hostler': hostler,
      'email': email,
      'kietEmail': kietEmail,
      'libId': libId,
      'profileImage': profileImage,
      'domain': domain
    });
  }

  verifyPhone(String phoneNumber, BuildContext context) async{
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91$phoneNumber',
        verificationCompleted: (PhoneAuthCredential credential) async{
          //Auto verification
          await FirebaseAuth.instance.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e){
          // Handling error
          if (kDebugMode) {
            print(e.message.toString());
          }
        },
        codeSent: (String verificationId, int? resendToken) async{
          // Handle OTP code sent
          // Typically, you would store verificationId to use later
          String smsCode = '999999'; //enter code manually
          PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
          final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
          final User? user = userCredential.user;
          if(user != null){
            Navigator.pushReplacementNamed(context, '');
          }
        },
        codeAutoRetrievalTimeout: (String verificationId){
          // Handle timeout for auto-retrieval of OTP
        });
  }

  Future<void> uploadUserDetails({
    required String firstName,
    required String lastName,
    required String mobileNumber,
    required String address,
    required String email,
    required String lib,
  }) async {
    final firebaseMessaging = FirebaseMessaging.instance;
    final fcmToken = await firebaseMessaging.getToken();
    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).set({
      'firstName': firstName,
      'lastName': lastName,
      'mobileNumber': mobileNumber,
      'address': address,
      'fcm': fcmToken,
      'email': email,
      'lib':lib,
    });
  }

}