import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:innogeeks_app/constants/colors.dart';
import 'package:innogeeks_app/constants/dimensions.dart';
import 'package:innogeeks_app/constants/fonts.dart';
import 'package:innogeeks_app/features/doubts/repo/doubts_repo.dart';
import 'package:innogeeks_app/features/widgets/widgets.dart';

import '../../../main.dart';

class DoubtCardLarge extends StatelessWidget {
  final Map<String,dynamic> doubt;
  const DoubtCardLarge({
    super.key,
    required this.doubt
  });

  @override
  Widget build(BuildContext context) {

  List<Color> tagBorderColor = const [Color(0xff4169E1),Color(0xff228B22),Color(0xffDC143C),Color(0xffFF8C00),Color(0xff9932CC),Color(0xffFF1493),Color(0xff008080),Color(0xffDAA520),Color(0xff708090),Color(0xff191970)];
  List<Color> tagBgColor = const [Color(0xffDCE6FA), Color(0xffD8F1D8), Color(0xffFAD4DD), Color(0xffFFE7CC), Color(0xffEADAF5), Color(0xffFFD5E9), Color(0xffD1EAEA), Color(0xffFAF1D5), Color(0xffE4E8EE), Color(0xffD6D6E9),];
  int getDesiredColor(String value){
    var random = Random();
    String valueNew = value.substring(random.nextInt(value.length));
    int indexFull =  int.parse((valueNew.toUpperCase().codeUnitAt(0).toString())[1]);
    return indexFull;
  }

  String getDetailedTimeDifference(int storedTimestamp) {
    if (storedTimestamp > 9999999999999) {
      storedTimestamp = (storedTimestamp / 1000).round();
    }
    DateTime storedTime = DateTime.fromMillisecondsSinceEpoch(storedTimestamp);
    DateTime currentTime = DateTime.now();
    Duration difference = currentTime.difference(storedTime);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 30) {
      return '${difference.inDays}d';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()}mo';
    } else {
      return '${(difference.inDays / 365).floor()}y';
    }
  }
  ValueNotifier<int> upVoteValue = ValueNotifier<int>(0);
  // String imageUrl = 'https://images.unsplash.com/photo-1731453171628-635e49577b59?q=80&w=2787&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D';
  final timestamp = int.parse(doubt['timestamp']);
  String assetType = doubt['asset'].split(' ').first;

    return Container(
      padding: EdgeInsets.symmetric(vertical: getScreenHeight(context)*0.01,horizontal: getScreenWidth(context)*0.028),
      decoration: const BoxDecoration(
        border: BorderDirectional(bottom: BorderSide(color: borderColor)),
        color: Colors.white,
      ),
      child: Column(
        spacing: getScreenHeight(context)*0.01,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: getScreenWidth(context),
            child: Row(
              spacing: getScreenWidth(context)*0.01,
              children: [
                SmallTextType(text: doubt['username'],size: getScreenWidth(context)*0.041,),
                SmallTextType(text: getDetailedTimeDifference(timestamp),size: getScreenWidth(context)*0.041),
                SmallTextType(text: '·',size: getScreenWidth(context)*0.045,color: slateGrayTagBorder,),
                SizedBox(
                  width: getScreenWidth(context)*0.55,
                  height: getScreenHeight(context)*0.03,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: doubt['tags'].length,
                      itemBuilder: (context,index){
                      final int indexValue = getDesiredColor(doubt['tags'][index]);
                      Color borderColor = tagBorderColor[indexValue];
                      Color bgColor = tagBgColor[indexValue];
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: getScreenWidth(context)*0.005),
                        padding: EdgeInsets.symmetric(horizontal: getScreenWidth(context)*0.018),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor),
                          color: bgColor
                        ),
                        child: SimpleChildButton(
                            onTap: (){},
                            splashColor: borderColor,
                            child: SmallTextType(text: doubt['tags'][index],color: borderColor,size: getScreenWidth(context)*0.041)),
                      );
                      }),
                ),
                const Spacer(),
                Icon(CupertinoIcons.ellipsis_vertical,size: getScreenWidth(context)*0.055,)
              ],
            ),
          ),
          SizedBox(
            width: getScreenWidth(context),
            child: SmallTextType(
              text: doubt['title'],
              overflow: TextOverflow.ellipsis,
            )
          ),
          if(assetType=='img')
            Container(
                margin: EdgeInsets.symmetric(horizontal: getScreenWidth(context)*0.02),
                width: getScreenWidth(context),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: borderColor)
                ),
                clipBehavior: Clip.hardEdge,
                child: Image.network(
                    doubt['asset'].split(' ').last,
                    fit: BoxFit.fitWidth
                )
            ),
          if(assetType=='video')
            Container(),
          if(assetType.isEmpty)
            SizedBox(
            width: getScreenWidth(context),
            child: SmallTextType(
              text: doubt['body'],
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              weight: FontWeight.w500,
              size: getScreenWidth(context)*0.038,
            ),
          ),
          SizedBox(
            width: getScreenWidth(context),
            child: Row(
              spacing: getScreenWidth(context)*0.01,
              children: [
                Container(
                  margin: EdgeInsets.only(left: getScreenWidth(context)*0.03),
                  padding: EdgeInsets.all(getScreenWidth(context)*0.015),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: borderColor)
                  ),
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('users').doc(userIdMain).snapshots(),
                    builder: (context,snapshot) {
                      if(!snapshot.hasData){
                        return Row(
                            spacing: getScreenWidth(context)*0.01,
                            children: [
                              Icon(CupertinoIcons.arrow_up_circle,size: getScreenWidth(context)*0.06),
                              SmallTextType(text: '${doubt['upvotes']}',weight: FontWeight.w500,size: getScreenWidth(context)*0.042),
                              Transform.rotate(
                                  angle: 1.5708,
                                  child: SizedBox(
                                      width: getScreenWidth(context)*0.04,
                                      child: const Divider(
                                        thickness: 0.8,
                                        color: borderColor,
                                      ))
                              ),
                              Icon(CupertinoIcons.arrow_down_circle,size: getScreenWidth(context)*0.06),
                            ]
                        );
                      }
                      else if(snapshot.hasError){
                        return Row(
                            spacing: getScreenWidth(context)*0.01,
                            children: [
                              Icon(CupertinoIcons.arrow_up_circle,size: getScreenWidth(context)*0.06),
                              SmallTextType(text: '${doubt['upvotes']}',weight: FontWeight.w500,size: getScreenWidth(context)*0.042),
                              Transform.rotate(
                                  angle: 1.5708,
                                  child: SizedBox(
                                      width: getScreenWidth(context)*0.04,
                                      child: const Divider(
                                        thickness: 0.8,
                                        color: borderColor,
                                      ))
                              ),
                              Icon(CupertinoIcons.arrow_down_circle,size: getScreenWidth(context)*0.06),
                            ]
                        );
                      }
                      else{
                        final data = snapshot.data!.data();
                        List<dynamic> upVotedList = data!['upVoted'];
                        List<dynamic> downVotedList = data['downVoted'];
                        return Row(
                            spacing: getScreenWidth(context)*0.01,
                            children: [
                              SimpleChildButton(
                                  onTap:(){
                                    (upVotedList.contains(doubt['id']))?
                                        {if(upVoteValue.value!=-1&&upVoteValue.value!=-2)DoubtsRepo.upVotePost(doubt['id'], -1, 'up'), if(upVoteValue.value!=-1&&upVoteValue.value!=-2)upVoteValue.value--}:
                                    (downVotedList.contains(doubt['id']))?
                                        {if(upVoteValue.value!=1&&upVoteValue.value!=2)DoubtsRepo.upVotePost(doubt['id'], 2, 'up'),upVoteValue.value++,upVoteValue.value++}:
                                        {if(upVoteValue.value!=1&&upVoteValue.value!=2)DoubtsRepo.upVotePost(doubt['id'], 1, 'up'),if(upVoteValue.value!=1&&upVoteValue.value!=2)upVoteValue.value++};
                                },
                                  child: Icon(CupertinoIcons.arrow_up_circle,size: getScreenWidth(context)*0.06,color: (upVotedList.contains(doubt['id']))? primaryInnoColor:Colors.black,)),
                              ValueListenableBuilder(
                                valueListenable:upVoteValue,
                                builder: (context,_,__) {
                                  return SmallTextType(text: '${upVoteValue.value+doubt['upvotes']}',weight: FontWeight.w500,size: getScreenWidth(context)*0.042);
                                }
                              ),
                              Transform.rotate(
                                  angle: 1.5708,
                                  child: SizedBox(
                                      width: getScreenWidth(context)*0.04,
                                      child: const Divider(
                                        thickness: 0.8,
                                        color: borderColor,
                                      ))
                              ),
                              SimpleChildButton(
                                  onTap:(){
                                    (downVotedList.contains(doubt['id']))?
                                      {if(upVoteValue.value!=1&&upVoteValue.value!=2)DoubtsRepo.upVotePost(doubt['id'], 1, 'down'),if(upVoteValue.value!=1&&upVoteValue.value!=2)upVoteValue.value++}:
                                    (upVotedList.contains(doubt['id']))?
                                      {if(upVoteValue.value!=-1&&upVoteValue.value!=-2)DoubtsRepo.upVotePost(doubt['id'], -2, 'down'),upVoteValue.value--,upVoteValue.value--}:
                                      {if(upVoteValue.value!=-1&&upVoteValue.value!=-2)DoubtsRepo.upVotePost(doubt['id'], -1, 'down'),if(upVoteValue.value!=-1&&upVoteValue.value!=-2)upVoteValue.value--};
                                    },
                                  child: Icon(CupertinoIcons.arrow_down_circle,size: getScreenWidth(context)*0.06,color: (downVotedList.contains(doubt['id']))?Colors.red:Colors.black,)),
                            ]
                        );
                      }

                    }
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: getScreenWidth(context)*0.03),
                  padding: EdgeInsets.symmetric(vertical:getScreenWidth(context)*0.015,horizontal: getScreenWidth(context)*0.02),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: borderColor)
                  ),
                  child: Row(
                    spacing: getScreenWidth(context)*0.02,
                    children: [
                      Icon(CupertinoIcons.chat_bubble,size: getScreenWidth(context)*0.06),
                      SmallTextType(text: '${doubt['answersCount']}',weight: FontWeight.w500,size: getScreenWidth(context)*0.042),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
