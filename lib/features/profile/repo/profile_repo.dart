import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:innogeeks_app/constants/innogeeks_fcm.dart';

class ProfileRepo {

  static Future<String> uploadImage() async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? file = await imagePicker.pickImage(source: ImageSource.camera);

    if (file == null) return '';

    try {
      final File imageFile = File(file.path);

      // Compress the image
      final decodedImage = img.decodeImage(imageFile.readAsBytesSync());
      final compressedImage = img.encodeJpg(decodedImage!,
          quality: 15); // Adjust the quality as needed

      final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final Reference referenceRoot = FirebaseStorage.instance.ref();
      final Reference referenceDirImage = referenceRoot.child('images');
      final Reference referenceImageToUpload =
      referenceDirImage.child('$fileName.jpg');

      await referenceImageToUpload
          .putData(compressedImage); // Use putData instead of putFile

      final String imageUrl = await referenceImageToUpload.getDownloadURL();
      return imageUrl;
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading image: $e');
      }
      return '';
    }
  }

  static Future<String> selectImage() async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? file =
    await imagePicker.pickImage(source: ImageSource.gallery);

    if (file == null) return '';

    try {
      final File imageFile = File(file.path);

      // Compress the image
      final decodedImage = img.decodeImage(imageFile.readAsBytesSync());
      final compressedImage = img.encodeJpg(decodedImage!,
          quality: 15); // Adjust the quality as needed

      final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final Reference referenceRoot = FirebaseStorage.instance.ref();
      final Reference referenceDirImage = referenceRoot.child('images');
      final Reference referenceImageToUpload =
      referenceDirImage.child('$fileName.jpg');

      await referenceImageToUpload
          .putData(compressedImage); // Use putData instead of putFile

      final String imageUrl = await referenceImageToUpload.getDownloadURL();
      return imageUrl;
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading image: $e');
      }
      return '';
    }
  }

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

  static getAccessToken() async{
    const serviceAccountJSON = serviceJson;

    List<String> scopes = [
      'https://www.googleapis.com/auth/firebase.messaging'
    ];

    http.Client client = await auth.clientViaServiceAccount(
        auth.ServiceAccountCredentials.fromJson(serviceAccountJSON),
        scopes
    );

    // get access token
    auth.AccessCredentials credentials = await auth.obtainAccessCredentialsViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJSON),
      scopes,
      client,
    );

    client.close();

    return credentials.accessToken.data;
  }

  static Future<List<String>> getUserFcmTokens(String listName) async{
    final colRef = FirebaseFirestore.instance.collection('fcmtokens');
    final docRef = await colRef.doc(listName).get();
    try{
      if(docRef.exists){
        final data = docRef.get('fcms');
        return data;
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

  static sendPushMessage({
    String page='',
    required String token,
    required String body,
    required String title,
    String imageUrl='',
    bool titleNamed = false,
    bool bodyNamed = false,
  }) async {
    final String serverKey = await getAccessToken();
    const endpointFirebaseCloudMessaging = 'https://fcm.googleapis.com/v1/projects/innogeeks-app/messages:send';
    if(title.isEmpty){
      final collectionRef = FirebaseFirestore.instance.collection('fcmtokens');
      final docGet = await collectionRef.doc('fcmUsers').collection('fcms').doc(token).get();
      if(docGet.exists){
        title = docGet.get('name');
        if (kDebugMode) {
          print('name');
        }
      }
    }
    if(titleNamed){
      try{
        final collectionRef = FirebaseFirestore.instance.collection('fcmtokens');
        final docGet = await collectionRef.doc('fcmUsers').collection('fcms').doc(token).get();
        List titles = title.split('_');
        String newTitle = '';
        int i=0;
        for(i; i<titles.length-1;i++){
          newTitle =newTitle + titles[i] + docGet.get('name');
        }
        if (kDebugMode) {
          print(titles);
        }
        title = newTitle + titles.last;
      }catch(e){
        if (kDebugMode) {
          print(e.toString());
        }
      }
    }
    if(bodyNamed){
      try{
        final collectionRef = FirebaseFirestore.instance.collection('fcmtokens');
        final docGet = await collectionRef.doc('fcmUsers').collection('fcms').doc(token).get();
        List titles = body.split('_');
        String newTitle = '';
        int i=0;
        for(i; i<titles.length-1;i++){
          newTitle =newTitle + titles[i] + docGet.get('name');
        }
        print(titles);
        body = newTitle + titles.last;
      }catch(e){
        print(e.toString());
      }
    }
    final Map<String, dynamic> message =
    {
      "message" :
      {
        "token" : token,
        "notification": <String, dynamic>{
          "title": title,
          "body": body,
          "image": imageUrl,
          "content_available": true
        },
        'data': <String, dynamic>{
          "click_action": "FLUTTER_NOTIFICATION_CLICK",
          "status": "done",
          "type":page,
          "body": body,
          "title": title,
          "main_picture": imageUrl,
        },
      }
    };
    final http.Response response = await http.post(
      Uri.parse(endpointFirebaseCloudMessaging),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
        'Bearer $serverKey'
      },
      body: jsonEncode(message),
    );
    if(response.statusCode == 200){
      if (kDebugMode) {
        print('Notification Sent');
      }
    }
    else{
      if (kDebugMode) {
        print('Notification not Sent ${response.statusCode}');
        print(serverKey);
      }
    }
  }

  static Future<void> sendCustomImageNotification(
      {required String title, required String description, required String imageUrl, required bool titleNamed, required bool bodyNamed, String page = ''}) async {
    DocumentSnapshot tokensSnapshot = await FirebaseFirestore.instance
        .collection('fcmtokens')
        .doc('fcmdoc')
        .get();
    List<dynamic> fcmList = tokensSnapshot.get('fcms');
    for (var fcm in fcmList) {
      sendPushMessage(token: fcm, body: description, title: title, imageUrl: imageUrl, titleNamed: titleNamed, bodyNamed: bodyNamed,page: page);
      if (kDebugMode) {
        print("$fcm $description $title");
      }
    }
  }

  static flutterEmailSender({
    required String emailSubject,
    required String emailBody,
    required List<String> recipientsList,
    required List<String> ccList,
    required List<String> bccList,
  }) async{
    final Email email = Email(
      body: emailBody,
      subject: emailSubject,
      recipients: recipientsList,
      cc: ccList,
      bcc: bccList,
      // attachmentPaths: ['/path/to/attachment.zip'],
    );
    await FlutterEmailSender.send(email);
  }

}