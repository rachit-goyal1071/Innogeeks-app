import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:innogeeks_app/models/student_data_model.dart';
import 'package:to_csv/to_csv.dart';

class RecruitmentRepo{

  static Future<List<String>> recruitmentDataIdList() async{
    final colRef = FirebaseFirestore.instance.collection('registration');
    final docRef = await colRef.doc((DateTime.now().year +4).toString()).get();
    try{
      if(docRef.exists){
        final idList = await colRef
            .doc((DateTime.now().year +4).toString())
            .collection('registeredUsers').get();
        final docsList = idList.docs;
        List<String> registeredUserIds = [];
        for(int i=0;i<docsList.length;i++){
          registeredUserIds.add(docsList[i].id);
        }
        return registeredUserIds;
      }else{
        return [];
      }
    }catch(e){
      if(kDebugMode){
        print(e.toString());
      }
      return [];
    }
  }

  static Future<StudentDataModel> recruitmentDataUserDetails(String userId) async{
    final colRef = FirebaseFirestore.instance.collection('registration');
    final docRef = await colRef.doc((DateTime.now().year +4).toString()).collection('registeredUsers').doc(userId).get();
    try{
      if(docRef.exists){
        final data = StudentDataModel.fromMap(docRef.data() as Map<String,dynamic>);
        return data;
      }else{
        return StudentDataModel.fromMap({});
      }
    }catch(e){
      if(kDebugMode){
        print(e.toString());
      }
      return StudentDataModel.fromMap({});
    }
  }

  static Future<List<StudentDataModel>> recruitmentDataUserDetailsList() async{
    try{
        final userList = await recruitmentDataIdList();
        List<StudentDataModel> userDataList = [];
        for(int i=0;i<userList.length;i++){
          userDataList.add(await recruitmentDataUserDetails(userList[i]));
          }
        return userDataList;
    }catch(e){
      if(kDebugMode){
        print(e.toString());
      }
      return [];
    }
  }

  static Future<void> convertMapToList(List<StudentDataModel> listOfLists) async{
    List<List<String>> convertedList = [[
      'Name',
      'Email',
      'College Email',
      'Mobile Number',
      'Gender',
      'Library Id',
      'Branch',
      'Address',
      'Description'
    ]];
    try{
      for(int i=0;i<listOfLists.length;i++){
        convertedList.add([
          listOfLists[i].name,
          listOfLists[i].email,
          listOfLists[i].collegeMail,
          listOfLists[i].mobileNumber,
          listOfLists[i].gender,
          listOfLists[i].lib,
          listOfLists[i].branch,
          listOfLists[i].address,
          listOfLists[i].description,
        ]);
      }
      exportCsvFile([
        'Name',
        'Email',
        'College Email',
        'Mobile Number',
        'Gender',
        'Library Id',
        'Branch',
        'Address',
        'Description'
      ], convertedList);
      // return convertedList;
    }catch(e){
      if(kDebugMode){
        print(e.toString());
      }
      // return [];
    }
  }

  static Future exportCsvFile(List<String> header,List<List<String>> listOfLists) async{
    await myCSV(
        header,
        listOfLists
    );
  }

}