import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:innogeeks_app/constants/fonts.dart';
import 'package:innogeeks_app/features/auth/ui/sign_in_page.dart';
import 'package:innogeeks_app/features/widgets/widgets.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const SmallTextType(text: 'Profile'),
      ),
      body: Container(
        child: GestureDetector(
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
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) => SignInPage()));},
                            child: const Text('Yes',style: TextStyle(color: Colors.black),))
                      ],
                    );
                  }
              );
            },
            child: const CustomButton(text: "LogOut")),
      ),
    );
  }
}
