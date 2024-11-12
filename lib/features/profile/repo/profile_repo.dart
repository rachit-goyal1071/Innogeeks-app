import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class ProfileRepo {
  static Future<Map<String, dynamic>> getProfileDetails() async {
    final colRef = FirebaseFirestore.instance.collection('users');
    final docRef = await colRef.doc(FirebaseAuth.instance.currentUser!.uid).get();
    try{
      if(docRef.exists){
        final value = docRef.data() as Map;
        if (kDebugMode) {
          print(value);
        }
        return value as Map<String, dynamic>;
      }
      else {
        return {};
      }
    }catch(e){
      if (kDebugMode) {
        print(e.toString());
      }
      return {};
    }
  }
}