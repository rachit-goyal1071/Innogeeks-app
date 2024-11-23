import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:innogeeks_app/main.dart';

class RegistrationRepo{

  static Future<void> registerNewCandidate({
    required String name,
    required String email,
    required String collegeMail,
    required String gender,
    required String branch,
    required bool isHosteller,
    required String address,
    required String mobileNumber,
    required String lib,
    required String description,
}) async{
    final colRef = FirebaseFirestore.instance.collection('registration');
    final docRef = await colRef.doc((DateTime.now().year+4).toString()).get();
    final userDocRef = FirebaseFirestore.instance.collection('users').doc(userIdMain);
    if(docRef.exists){
      await colRef.doc((DateTime.now().year+4).toString()).update({'registrationCount':FieldValue.increment(1)});
      await colRef.doc((DateTime.now().year+4).toString())
          .collection('registeredUsers')
          .doc(userIdMain)
          .update({
        'name':name,
        'email':email,
        'collegeMail':collegeMail,
        'gender':gender,
        'branch':branch,
        'isHosteller':isHosteller,
        'address':address,
        'mobileNumber':mobileNumber,
        'lib':lib,
        'description':description,
        'fee':false
      });
      await userDocRef
            .update({
        'collegeMail':collegeMail,
        'gender':gender,
        'branch':branch,
        'isHosteller':isHosteller,
        'address':address,
        'lib':lib,
        'description':description,
        'fee':false,
        'isRegistered':true
      });
    }
    else{
      await colRef.doc((DateTime.now().year+4).toString()).set({'userCount':1});
      await colRef.doc((DateTime.now().year+4).toString()).update({'paidCount':0});
      await colRef.doc((DateTime.now().year+4).toString())
          .collection('registeredUsers')
          .doc(userIdMain)
          .set({
        'name':name,
        'email':email,
        'collegeMail':collegeMail,
        'gender':gender,
        'branch':branch,
        'isHosteller':isHosteller,
        'address':address,
        'mobileNumber':mobileNumber,
        'lib':lib,
        'description':description,
        'fee':false,
      });
      await userDocRef
          .update({
        'collegeMail':collegeMail,
        'gender':gender,
        'branch':branch,
        'isHosteller':isHosteller,
        'address':address,
        'lib':lib,
        'description':description,
        'fee':false,
        'isRegistered':true
      });
    }
  }

  static Future<void> completePaymentStatus() async{
    print('object:was called2');
    final colRef = FirebaseFirestore.instance.collection('registration');
    final docRef = await colRef.doc((DateTime.now().year+4).toString()).get();
    final userDocRef = FirebaseFirestore.instance.collection('users').doc(userIdMain);
    try{
      if(docRef.exists){
        await colRef.doc((DateTime.now().year+4).toString()).update({'paidCount':FieldValue.increment(1)});
        await colRef.doc((DateTime.now().year+4).toString())
            .collection('registeredUsers')
            .doc(userIdMain)
            .update({
          'fee':true
        });
        print('object:was called');
        await userDocRef
            .update({
          'fee':true,
        });
      }
    }catch(e){
      if(kDebugMode){
        print(e.toString());
      }
    }
  }

  static Future<bool> checkUserRegistrationStatus() async{
    final docRef = await FirebaseFirestore.instance.collection('users').doc(userIdMain).get();
    if(docRef.exists){
      try{
        final bool value = await docRef.get('isRegistered');
        return value;
      }catch(e){
        if(kDebugMode){
          print(e.toString());
        }
        return false;
      }
    }else{
      return false;
    }
  }

  static Future<Map<String, dynamic>> getRegistrationDetails() async{
    final docRef = await FirebaseFirestore.instance
        .collection('registration')
        .doc((DateTime.now().year+4).toString())
        .collection('registeredUsers')
        .doc(userIdMain)
        .get();
    if(docRef.exists){
      try{
        final data = docRef.data() as Map;
        return data as Map<String,dynamic>;
      }catch(e){
        if(kDebugMode){
          print(e.toString());
        }
        return {};
      }
    }else{
      return {};
    }
  }

  static Future<String> getFeeAmount() async{
    final docRef = await FirebaseFirestore.instance.collection('fee').doc('registrationFee').get();
    if(docRef.exists){
      final data = docRef.get('fee');
      return data;
    }else{
      return '';
    }
  }
}