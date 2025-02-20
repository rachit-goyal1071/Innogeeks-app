import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innogeeks_app/constants/colors.dart';
import 'package:innogeeks_app/constants/dimensions.dart';
import 'package:innogeeks_app/constants/fonts.dart';
import 'package:innogeeks_app/features/auth/ui/sign_in_page.dart';
import 'package:innogeeks_app/features/auth/ui/user_details_page.dart';
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
  ValueNotifier<bool> switch1 = ValueNotifier<bool>(false);
  ValueNotifier<bool> switch2 = ValueNotifier<bool>(false);

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
                                            imageUrl = await ProfileRepo.selectImage('notification',false);
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
                                            body: descriptionController.text.trim(),
                                            title: titleController.text.trim()
                                        );
                                        Navigator.pop(context);
                                      },
                                      child:
                                      const CustomButton(radius: 6, text: 'Send Notification',width: 0.4,))
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
        listenWhen: (previous,current)=> current is ProfileActionState,
        buildWhen: (previous,current)=> current is! ProfileActionState,
        listener: (context, state) {
          if(state is ProfilePageFetchingState){
            showDialog(
                context: context,
                builder: (context){
                  return const UserDetailsPage();
                }
            );
          }
        },
        builder: (context, state) {
    switch (state.runtimeType){
      case ProfileLoadedSuccessState:
        final successState = state as ProfileLoadedSuccessState;
        return Container(
          margin: EdgeInsets.symmetric(horizontal: getScreenWidth(context)*0.045),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: getScreenWidth(context)*0.15,
                  foregroundImage: successState.data['profile']!=null?
                  NetworkImage(successState.data['profile']):
                  const NetworkImage('https://firebasestorage.googleapis.com/v0/b/johar-basket.appspot.com/o/profile%2Fdefault%2Fimg_user.jpg?alt=media&token=7cfa51a9-f0c8-4552-a8b6-a528db30f963'),
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
                child: Column(
                  children: [
                    SmallTextType(
                      text: ('${successState.data['firstName']} ${successState.data['lastName']}' ),
                      color: Colors.black,
                      size: getScreenWidth(context)*0.07,
                    ),
                    SmallTextType(
                      text: successState.data['email'],
                      color: const Color(0xff8f959c),
                      size: getScreenWidth(context)*0.0395,
                      weight: FontWeight.w700,
                    ),
                    SizedBox(height: getScreenHeight(context)*0.02,),
                    SimpleTextButton(
                        weight: FontWeight.w400,
                        color: Colors.black,
                        radius: 25,
                        text: 'Edit profile',
                        onTap: (){}
                    ),
                  ],
                ),
              ),
              const SmallTextType(text: 'Inventories',color: commonFontColor,),
              Container(
                margin: EdgeInsets.only(top: getScreenHeight(context)*0.015),
                decoration: BoxDecoration(
                    border: Border.all(color: borderColor),
                    borderRadius: BorderRadius.circular(20)
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: SmallTextType(text: 'Text',size: getScreenWidth(context)*0.05,),
                      leading: Container(decoration: BoxDecoration(color:Colors.white,borderRadius: BorderRadius.circular(5),boxShadow: kElevationToShadow[1]),padding: const EdgeInsets.all(1),child: Icon(Icons.home_outlined,color: commonFontColor,size: getScreenWidth(context)*0.076,)),
                      trailing: const Icon(Icons.arrow_forward,color: commonFontColor),
                      tileColor: commonBgColor,
                      textColor: Colors.blueAccent,
                      style: ListTileStyle.drawer,
                      shape:const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20))),
                    ),
                    Divider(indent: getScreenWidth(context)*0.04,endIndent: getScreenWidth(context)*0.04,color: borderColor,height: 0,),
                    ListTile(
                      title: SmallTextType(text: 'Text',size: getScreenWidth(context)*0.05,),
                      leading: Container(decoration: BoxDecoration(color:Colors.white,borderRadius: BorderRadius.circular(5),boxShadow: kElevationToShadow[1]),padding: const EdgeInsets.all(1),child: Icon(Icons.home_outlined,color: commonFontColor,size: getScreenWidth(context)*0.076,)),
                      trailing: const Icon(Icons.arrow_forward,color: commonFontColor,),
                      tileColor: commonBgColor,
                      textColor: Colors.blueAccent,
                      style: ListTileStyle.drawer,
                      shape:const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomRight: Radius.circular(20),bottomLeft: Radius.circular(20))),
                    )],
                ),
              ),
              SizedBox(height: getScreenHeight(context)*0.015,),
              const SmallTextType(text: 'Preferences',color: commonFontColor,),
              Container(
                margin: EdgeInsets.only(top: getScreenHeight(context)*0.015),
                decoration: BoxDecoration(
                    border: Border.all(color: borderColor),
                    borderRadius: BorderRadius.circular(20)
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: SmallTextType(text: 'Text',size: getScreenWidth(context)*0.05,),
                      leading: Container(decoration: BoxDecoration(color:Colors.white,borderRadius: BorderRadius.circular(5),boxShadow: kElevationToShadow[1]),padding: const EdgeInsets.all(1),child: Icon(Icons.home_outlined,color: commonFontColor,size: getScreenWidth(context)*0.076,)),
                      trailing: ValueListenableBuilder(
                        valueListenable: switch1,
                        builder: (context,_,__) {
                          return Switch(
                              inactiveTrackColor: Colors.white,
                              activeTrackColor: Colors.green,
                              activeColor: Colors.white,
                              value: switch1.value, onChanged: (value){
                            switch1.value=value;
                          });
                        }
                      ),
                      tileColor: commonBgColor,
                      textColor: Colors.blueAccent,
                      style: ListTileStyle.drawer,
                      shape:const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20))),
                    ),
                    Divider(indent: getScreenWidth(context)*0.04,endIndent: getScreenWidth(context)*0.04,color: borderColor,height: 0,),
                    ListTile(
                      title: SmallTextType(text: 'Text',size: getScreenWidth(context)*0.05,),
                      leading: Container(decoration: BoxDecoration(color:Colors.white,borderRadius: BorderRadius.circular(5),boxShadow: kElevationToShadow[1]),padding: const EdgeInsets.all(1),child: Icon(Icons.home_outlined,color: commonFontColor,size: getScreenWidth(context)*0.076,)),
                      trailing: ValueListenableBuilder(
                          valueListenable: switch2,
                          builder: (context,_,__) {
                            return Switch(
                                inactiveTrackColor: Colors.white,
                                activeTrackColor: Colors.green,
                                activeColor: Colors.white,
                                value: switch2.value, onChanged: (value){
                              switch2.value=value;
                            });
                          }
                      ),
                      tileColor: commonBgColor,
                      textColor: Colors.blueAccent,
                      style: ListTileStyle.drawer,
                      // shape:const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomRight: Radius.circular(20),bottomLeft: Radius.circular(20))),
                    ),
                    Divider(indent: getScreenWidth(context)*0.04,endIndent: getScreenWidth(context)*0.04,color: borderColor,height: 0,),
                    ListTile(
                      title: SmallTextType(text: 'Logout',size: getScreenWidth(context)*0.05,color: redRejectColor,),
                      leading: Container(decoration: BoxDecoration(color:const Color(0xffefd3d3),borderRadius: BorderRadius.circular(5),boxShadow: kElevationToShadow[1]),padding: const EdgeInsets.all(2.1),child: Icon(Icons.logout_outlined,color: redRejectColor,size: getScreenWidth(context)*0.07,)),
                      tileColor: commonBgColor,
                      textColor: Colors.blueAccent,
                      style: ListTileStyle.drawer,
                      shape:const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))),
                      onTap: (){
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
                                          overlayColor: WidgetStateProperty.resolveWith((states) => Colors.grey)
                                      ),
                                      onPressed: (){
                                        Navigator.pop(context);
                                      },
                                      child: const Text('No',style: TextStyle(color: Colors.black54),)),
                                  TextButton(
                                      style: ButtonStyle(
                                          overlayColor: WidgetStateProperty.resolveWith((states) => Colors.grey)
                                      ),
                                      onPressed: () async{
                                        await FirebaseAuth.instance.signOut();
                                        if(!context.mounted) return;
                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInPage()));},
                                      child: const Text('Yes',style: TextStyle(color: Colors.black),))
                                ],
                              );
                            }
                        );
                      },
                    ),
                  ],
                ),
              ),

              /* ############################ Email feature ############################### */
              // SimpleChildButton(onTap: (){
              //   ProfileRepo.flutterEmailSender(
              //       emailSubject: 'emailSubject',
              //       emailBody: 'emailBody',
              //       recipientsList: ['rg410345@gmail.com','rachit123secured@gmail.com'],
              //       ccList: [],
              //       bccList: []);
              // }, child: const SmallTextType(text: 'Send Email'))
              /* ############################ Email feature ############################### */
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
