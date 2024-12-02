import 'package:flutter/material.dart';
import 'package:innogeeks_app/constants/dimensions.dart';
import 'package:innogeeks_app/constants/fonts.dart';
import 'package:innogeeks_app/features/widgets/widgets.dart';
import 'package:innogeeks_app/models/student_data_model.dart';
import 'package:tap_to_expand/tap_to_expand.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentDataCard extends StatelessWidget {
  final String userId;
  final StudentDataModel userDetails;
  const StudentDataCard({
    super.key,
    required this.userId,
    required this.userDetails
  });

  @override
  Widget build(BuildContext context) {
    return TapToExpand(
        backgroundcolor: Colors.white,
        // openedHeight: getScreenHeight(context)*0.26,
        // isScrollable: true,
        iconColor: Colors.black,
        duration: const Duration(milliseconds: 250),
        title: SmallTextType(text: userDetails.name),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SmallTextType(text: 'Email',size: getScreenWidth(context)*0.04,weight: FontWeight.w400,),
                  SimpleChildButton(
                    onTap: (){
                      Uri mailTo = Uri.parse('mailto:${userDetails.email}');
                      launchUrl(mailTo);
                    },
                      child: SmallTextType(text: userDetails.email,size: getScreenWidth(context)*0.042,weight: FontWeight.w600,)),
                ],
              ),
            ),
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SmallTextType(text: 'College Email',size: getScreenWidth(context)*0.04,weight: FontWeight.w400,),
                  SimpleChildButton(
                      onTap: (){
                        Uri mailTo = Uri.parse('mailto:${userDetails.collegeMail}');
                        launchUrl(mailTo);
                      },
                      child: SmallTextType(text: userDetails.collegeMail,size: getScreenWidth(context)*0.042,weight: FontWeight.w600,)),
                ],
              ),
            ),
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SmallTextType(text: 'Phone No.',size: getScreenWidth(context)*0.04,weight: FontWeight.w400,),
                  SimpleChildButton(
                      onTap: (){
                        Uri mailTo = Uri.parse('tel:${userDetails.mobileNumber}');
                        launchUrl(mailTo,mode: LaunchMode.externalApplication,);
                      },
                      child: SmallTextType(text: userDetails.mobileNumber,size: getScreenWidth(context)*0.042,weight: FontWeight.w600,)),
                ],
              ),
            ),
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SmallTextType(text: 'Gender',size: getScreenWidth(context)*0.04,weight: FontWeight.w400,),
                  SmallTextType(text: userDetails.gender,size: getScreenWidth(context)*0.042,weight: FontWeight.w600),
                ],
              ),
            ),
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SmallTextType(text: 'Library ID',size: getScreenWidth(context)*0.04,weight: FontWeight.w400,),
                  SmallTextType(text: userDetails.lib,size: getScreenWidth(context)*0.042,weight: FontWeight.w600,),
                ],
              ),
            ),
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SmallTextType(text: 'Branch',size: getScreenWidth(context)*0.04,weight: FontWeight.w400,),
                  SmallTextType(text: userDetails.branch,size: getScreenWidth(context)*0.042,weight: FontWeight.w600,),
                ],
              ),
            ),
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SmallTextType(text: 'Address',size: getScreenWidth(context)*0.04,weight: FontWeight.w400,),
                  Flexible(child: SizedBox(width:getScreenWidth(context)*0.5,child: SmallTextType(text: userDetails.address,size: getScreenWidth(context)*0.042,weight: FontWeight.w600,overflow: TextOverflow.visible,))),
                ],
              ),
            ),
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SmallTextType(text: 'About Me:',size: getScreenWidth(context)*0.04,weight: FontWeight.w400,),
                  Flexible(child: SizedBox(width:getScreenWidth(context)*0.5,child: SmallTextType(text: userDetails.description,size: getScreenWidth(context)*0.042,weight: FontWeight.w600,overflow: TextOverflow.visible,))),
                ],
              ),
            ),
          ],
        ),
    );
  }
}
