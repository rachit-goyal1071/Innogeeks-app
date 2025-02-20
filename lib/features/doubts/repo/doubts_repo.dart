import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:innogeeks_app/main.dart';

class DoubtsRepo{

  static Future<String> fetchUsername() async{
    final docRef = await FirebaseFirestore.instance.collection('users').doc(userIdMain).get();
    return docRef.exists ? docRef.get('username') : '';
  }

  static Stream getUpVotedStatus = FirebaseFirestore.instance.collection('users').doc(userIdMain).snapshots();

  static Future<void> upVotePost(String id, int toAdd, String upOrDownVote) async{
    final doubtDocRef = await FirebaseFirestore.instance.collection('doubts').doc('doubtsDoc').collection('doubts').doc(id).get();
    final userDocRef = await FirebaseFirestore.instance.collection('users').doc(userIdMain).get();
    try{
      if(doubtDocRef.exists){
        int value = doubtDocRef.get('upvotes') + toAdd;
        if(upOrDownVote=='up'){
          if(toAdd == 1){
            await FirebaseFirestore.instance.collection('users').doc(userIdMain).update({
              'upVoted':FieldValue.arrayUnion([id])
            });
          }else if(toAdd == -1){
            List<dynamic> list = userDocRef.get('upVoted');
            list.remove(id);
            await FirebaseFirestore.instance.collection('users').doc(userIdMain).update({
              'upVoted': list
            });
          }else if(toAdd == 2){
            List<dynamic> list = userDocRef.get('downVoted');
            list.remove(id);
            await FirebaseFirestore.instance.collection('users').doc(userIdMain).update({
              'downVoted': list
            });
            await FirebaseFirestore.instance.collection('users').doc(userIdMain).update({
              'upVoted':FieldValue.arrayUnion([id])
            });
          }
        }else if(upOrDownVote == 'down'){
          if(toAdd == -1){
            await FirebaseFirestore.instance.collection('users').doc(userIdMain).update({
              'downVoted':FieldValue.arrayUnion([id])
            });
          }else if(toAdd == 1){
            List<dynamic> list = userDocRef.get('downVoted');
            list.remove(id);
            await FirebaseFirestore.instance.collection('users').doc(userIdMain).update({
              'downVoted': list
            });
          }else if(toAdd == -2){
            List<dynamic> list = userDocRef.get('upVoted');
            list.remove(id);
            await FirebaseFirestore.instance.collection('users').doc(userIdMain).update({
              'upVoted': list
            });
            await FirebaseFirestore.instance.collection('users').doc(userIdMain).update({
              'downVoted':FieldValue.arrayUnion([id])
            });
          }
        }
        await FirebaseFirestore.instance.collection('doubts').doc('doubtsDoc').collection('doubts').doc(id).update({
          'upvotes': value
        });
      }
    }catch(e){
      if(kDebugMode){
        print(e.toString());
      }
    }
  }

  static Future<void> postNewDoubt({
    required String title,
    required String body,
    required String asset,
    required List<dynamic> tags
  }) async{
    final colRef = FirebaseFirestore.instance.collection('doubts');
    final docRef = await colRef.doc('doubtsDoc').get();
    final timeStamp = DateTime.now().microsecondsSinceEpoch.toString();
    final random = Random();
    final id = '${timeStamp}_${(random.nextInt(9000)+1000).toString()}';
    final username = await fetchUsername();
    // final colRef = await docRef.collection('doubts').get();

    try{
      if(docRef.exists){
        await colRef.doc('doubtsDoc').collection('doubts').doc(id).set({
          "id": id,
          "title": title,
          "body": body,
          "tags": tags,
          "author": FirebaseAuth.instance.currentUser!.uid,
          "timestamp": timeStamp,
          "upvotes": 0,
          "answersCount": 0,
          "asset":asset,
          'username': username
        });
      }
      // await colRef.doc('doubtsDoc').update({
      //   'doubtsList':FieldValue.arrayUnion([id])
      // });
    }catch(e){
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  static Future<List<dynamic>> getTagsList() async{
    final docRef =await FirebaseFirestore.instance.collection('doubts').doc('tags').get();
    try{
      if(docRef.exists){
        List<dynamic> dataList = await docRef.get('tagsList');
        return dataList;
      }else {
        return [];
      }
    }catch(e){
      if(kDebugMode){
        print(e.toString());
      }
      return [];
    }
  }

  static Future<List<Map<String,dynamic>>> fetchDoubtsList() async{
    try{
      final docRef = await FirebaseFirestore.instance.collection('doubts').doc('doubtsDoc').collection('doubts').get();
      final data = docRef.docs.map((doc)=> doc.data()).toList();
      return data;
    }catch(e){
      if(kDebugMode){
        print(e.toString());
      }
      return [];
    }
  }

}