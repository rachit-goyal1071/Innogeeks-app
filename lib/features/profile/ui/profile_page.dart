import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innogeeks_app/constants/dimensions.dart';
import 'package:innogeeks_app/constants/fonts.dart';
import 'package:innogeeks_app/features/auth/ui/sign_in_page.dart';
import 'package:innogeeks_app/features/profile/bloc/profile_bloc.dart';
import 'package:innogeeks_app/features/profile/repo/profile_repo.dart';
import 'package:innogeeks_app/features/widgets/widgets.dart';

import '../../widgets/text_field.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  bool isThereError = false;
  TextEditingController pageNameController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String imageUrl = '';
  ProfileBloc profileBloc = ProfileBloc();

  // getDetails() async{
  //   final data = await ProfileRepo.getProfileDetails();
  //   setState(() {
  //     personalData = data;
  //   });
  // }

  @override
  void initState(){
    super.initState();
    profileBloc.add(ProfileInitialEvent());
    // getDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const SmallTextType(text: 'Profile'),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: getScreenWidth(context)*0.04,vertical: getScreenWidth(context)*0.01),
            child: SimpleChildButton(onTap: (){
              bool titleNamed = false;
              bool bodyNamed = false;
              showDialog(
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(
                        builder: (context,setState) {
                          return Dialog(
                            child: SizedBox(
                              height: getScreenHeight(context) * 0.62,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  DetailsTextField(
                                      controller: titleController,
                                      label: 'Notification title'),
                                  DetailsTextField(
                                      controller: descriptionController,
                                      label: 'Description'),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        TextButton(
                                          onPressed: () async{
                                            imageUrl = await ProfileRepo.selectImage();
                                            // Fluttertoast.showToast(msg: "Image Uploaded",backgroundColor: Colors.green,textColor: Colors.white);
                                          },
                                          child: const Text("SELECT IMAGE"),
                                        ),
                                        TextButton(onPressed: (){
                                          setState((){});
                                        }, child: const Text('Verify'))
                                      ],
                                    ),
                                  ),
                                  if(imageUrl.isNotEmpty)
                                    const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('Image Uploaded',overflow: TextOverflow.clip,),
                                        Icon(Icons.check,color: Colors.green,),
                                      ],
                                    ),
                                  const Text("Use _ to replace it with name"),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Checkbox(
                                        value: titleNamed,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            titleNamed = value!;
                                          });
                                        },
                                        semanticLabel: 'Title Named',
                                      ),
                                      Checkbox(
                                        value: bodyNamed,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            bodyNamed = value!;
                                          });
                                        },
                                        semanticLabel: 'Body Named',
                                      ),
                                    ],
                                  ),
                                  DetailsTextField(
                                      controller: pageNameController,
                                      label: 'Page Name and Number(use _)'),
                                  GestureDetector(
                                      onTap: () {
                                        ProfileRepo.sendPushMessage(
                                            token: 'cC3UEiUbRjSRWqAHnzm-LX:APA91bHWxrsBLqoW8Me67VZlfzjjzGx_5eZn6dB12QYkS6imvxb_KNShPAU9KYter5Xxx8KWAr1W3D4_8DWEWAUcJMvjweBCpmd8IM2qy_pypRHNa9PVgCjDSbsr8BBqSTpUfcrpY3GU',
                                            body: descriptionController.text,
                                            title: titleController.text
                                        );
                                        Navigator.pop(context);
                                      },
                                      child:
                                      CustomButton(radius: 6, text: 'Send Notification',width: 0.4,))
                                ],
                              ),
                            ),
                          );
                        }
                    );
                  });
            }, child:const Icon(Icons.notifications_none_rounded)),
          )
        ],
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        bloc: profileBloc,
        listener: (context, state) {

        },
        builder: (context, state) {
    switch (state.runtimeType){
      case ProfileLoadedSuccessState:
        final successState = state as ProfileLoadedSuccessState;
        return Container(
          margin: EdgeInsets.symmetric(horizontal: getScreenWidth(context)*0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: getScreenWidth(context)*0.15,
                  foregroundImage: successState.data['profile']!=null?
                  NetworkImage(successState.data['profile']):
                  const NetworkImage('https://firebasestorage.googleapis.com/v0/b/innogeeks-app.firebasestorage.app/o/img%2Fimg_user.jpg?alt=media&token=dbc339df-0547-4e2d-b182-606d6a7e0bd7'),
                  onForegroundImageError: (_,__){
                    setState(() {
                      isThereError = !isThereError;
                    });
                  },
                  // child: Image.network(successState.datae.personalData['profileImg']),
                ),
              ),
              SizedBox(height: getScreenHeight(context)*0.01,),
              Center(
                child: SmallTextType(
                  text: successState.data['firstName'],
                  color: Colors.green,
                ),
              ),
              SimpleTextButton(
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
                  text: "LogOut",),
              // SimpleChildButton(onTap: (){
              //   ProfileRepo.flutterEmailSender(
              //       emailSubject: 'emailSubject',
              //       emailBody: 'emailBody',
              //       recipientsList: ['rg410345@gmail.com','rachit123secured@gmail.com'],
              //       ccList: [],
              //       bccList: []);
              // }, child: const SmallTextType(text: 'Send Email'))
            ],
          ),
        );
     default:
       return const Center(child: CircularProgressIndicator(color: Colors.green,),);
    }
  },
),
    );
  }
}
