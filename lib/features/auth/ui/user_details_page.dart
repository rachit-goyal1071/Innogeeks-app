import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:innogeeks_app/constants/fonts.dart';
import 'package:innogeeks_app/main.dart';

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
  final libController = TextEditingController();
  final emailController = TextEditingController();
  String? phone = '';

  void getPhoneNumber() {
    phone = FirebaseAuth.instance.currentUser!.phoneNumber;
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
        .set({'name': firstName,'uid':userIdMain});
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
            DetailsTextField(controller: addressController, label: 'Address',icon:IconButton(
                onPressed: (){
                  showDialog(
                      context: context, builder: (context){
                        return const Dialog(
                          backgroundColor:Colors.white,child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: SmallTextType(text: 'Add Current Address'),
                        ),);
                      });},
                icon: const Icon(Icons.info_outline)),),
            DetailsTextField(
              controller: libController,
              label: 'Library ID',
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: getScreenWidth(context) * 0.07),
            TextButton(
              onPressed: () async {
                if(firstNameController.text.trim().isEmpty || lastNameController.text.trim().isEmpty || mobileController.text.trim().isEmpty || emailController.text.trim().isEmpty || libController.text.trim().isEmpty){
                  return openErrorSnackBar(context, "Please add complete details");
                }
                else {
                  await AuthService().uploadUserDetails(
                    firstName: firstNameController.text.trim(),
                    lastName: lastNameController.text.trim(),
                    mobileNumber: mobileController.text.trim(),
                    address: addressController.text.trim(),
                    email: emailController.text.trim(),
                    lib: libController.text.trim()
                  );
                  uploadFcm(firstNameController.text.trim());
                  if(!context.mounted) return;
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