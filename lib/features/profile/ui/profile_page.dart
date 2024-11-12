import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:innogeeks_app/constants/dimensions.dart';
import 'package:innogeeks_app/constants/fonts.dart';
import 'package:innogeeks_app/features/auth/ui/sign_in_page.dart';
import 'package:innogeeks_app/features/profile/repo/profile_repo.dart';
import 'package:innogeeks_app/features/widgets/widgets.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  Map<String,dynamic> personalData = <String,dynamic>{};
  bool isThereError = false;

  getDetails() async{
    final data = await ProfileRepo.getProfileDetails();
    setState(() {
      personalData = data;
    });
  }

  @override
  void initState(){
    super.initState();
    getDetails();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const SmallTextType(text: 'Profile'),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: getScreenWidth(context)*0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: getScreenWidth(context)*0.15,
                foregroundImage:
                !isThereError?
                NetworkImage(personalData['profile']):
                NetworkImage('https://firebasestorage.googleapis.com/v0/b/innogeeks-app.firebasestorage.app/o/img%2Fimg_user.jpg?alt=media&token=dbc339df-0547-4e2d-b182-606d6a7e0bd7'),
                onForegroundImageError: (_,__){
                  setState(() {
                    isThereError = !isThereError;
                  });
                },
                // child: Image.network(successState.personalData['profileImg']),
              ),
            ),
            SizedBox(height: getScreenHeight(context)*0.01,),
            SimpleButton(
                onTap:(){
                  showDialog(
                      context: context,
                      builder: (BuildContext context){
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          title: const Text('Sign Out?'),
                          content: const Text('Do you really want to Sign out?'),
                          actions: <Widget>[
                            TextButton(
                                style: ButtonStyle(
                                    overlayColor: MaterialStateProperty.resolveWith((states) => Colors.grey)
                                ),
                                onPressed: (){
                                  Navigator.pop(context);
                                },
                                child: const Text('No',style: TextStyle(color: Colors.black54),)),
                            TextButton(
                                style: ButtonStyle(
                                    overlayColor: MaterialStateProperty.resolveWith((states) => Colors.grey)
                                ),
                                onPressed: () async{
                                  await FirebaseAuth.instance.signOut();
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInPage()));},
                                child: const Text('Yes',style: TextStyle(color: Colors.black),))
                          ],
                        );
                      }
                  );
                },
                child: const CustomButton(text: "LogOut")),
          ],
        ),
      ),
    );
  }
}
