import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants/dimensions.dart';
import '../../widgets/text_field.dart';
import '../../widgets/widgets.dart';
import '../services/auth_services.dart';

class UserDetailsPage extends StatefulWidget {
  const UserDetailsPage({super.key});

  @override
  State<UserDetailsPage> createState() => UserDetailsPageState();
}

class UserDetailsPageState extends State<UserDetailsPage> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final mobileController = TextEditingController();
  final addressController = TextEditingController();
  final pinController = TextEditingController();
  final emailController = TextEditingController();
  String? phone = '';

  void getPhoneNumber() async{
    phone = await FirebaseAuth.instance.currentUser!.phoneNumber;
    mobileController.text = phone!.substring(phone!.length - 10);
    setState(() {});
  }

  @override
  void initState() {
    getPhoneNumber();
    super.initState();
  }

  void uploadFcm(String firstName) async {
    final firebaseMessaging = FirebaseMessaging.instance;
    final fcm = await firebaseMessaging.getToken();
    final docRef = FirebaseFirestore.instance.collection('fcmtokens').doc('fcmdoc');
    DocumentSnapshot documentSnapshot = await docRef.get();
    List<String> currentArray = List<String>.from(documentSnapshot.get('fcms'));
    currentArray.add(fcm!);
    await docRef.update({'fcms': currentArray});

    await FirebaseFirestore.instance
        .collection('fcmtokens')
        .doc('fcmUsers')
        .collection('fcms')
        .doc(fcm)
        .set({'name': firstName});

    final docRef2 = FirebaseFirestore.instance.collection('fcmtokens').doc('fcmdoc3');
    DocumentSnapshot documentSnapshot2 = await docRef2.get();
    List<String> currentArray2 = List<String>.from(documentSnapshot2.get('fcms'));
    currentArray2.add(fcm!);
    await docRef2.update({'fcms': currentArray2});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        //  child: //SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // heading text
            Container(
              margin: EdgeInsets.all(getScreenWidth(context) * 0.07),
              child: Text(
                'Complete your profile',
                style: GoogleFonts.chivo(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: getScreenWidth(context) * 0.07,
                ),
              ),
            ),
            DetailsTextField(
                controller: firstNameController, label: 'First name'),
            DetailsTextField(
                controller: lastNameController, label: 'Last name'),
            DetailsTextField(
              clickable: false,
              controller: mobileController,
              label: 'Mobile Number',
              keyboardType: TextInputType.number,
            ),
            DetailsTextField(controller: emailController, label: "Email"),
            DetailsTextField(controller: addressController, label: 'Address'),
            DetailsTextField(
              controller: pinController,
              label: 'Pin code',
              keyboardType: TextInputType.number,
            ),

            SizedBox(height: getScreenWidth(context) * 0.07),
            TextButton(
              onPressed: () async {
                if(firstNameController.text.isEmpty || lastNameController.text.isEmpty || mobileController.text.isEmpty || emailController.text.isEmpty || pinController.text.isEmpty){
                  return openErrorSnackBar(context, "Please add complete details");
                }
                else {
                  await AuthService().uploadUserDetails(
                    firstName: firstNameController.text,
                    lastName: lastNameController.text,
                    mobileNumber: mobileController.text,
                    address: '',
                    email: emailController.text,
                  );
                  uploadFcm(firstNameController.text);
                  Navigator.pushReplacementNamed(context, '/');
                }
              },
              child: Container(
                alignment: Alignment.center,
                child: const CustomButton(
                  radius: 15,
                  text: 'Proceed',
                ),
              ),
            ),

            SizedBox(height: getScreenWidth(context) * 0.15),
          ],
        ),
        // )
      ),
    );
  }
}