import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:innogeeks_app/constants/colors.dart';
import 'package:innogeeks_app/features/doubts/bloc/doubts_bloc.dart';
import 'package:innogeeks_app/features/doubts/repo/doubts_repo.dart';
import 'package:innogeeks_app/features/doubts/ui/doubt_card_large.dart';
import 'package:innogeeks_app/features/profile/repo/profile_repo.dart';
import 'package:innogeeks_app/features/widgets/widgets.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';
import '../../../constants/dimensions.dart';
import '../../../constants/fonts.dart';
import '../widgets/widgets.dart';

class DoubtsPage extends StatefulWidget {
  const DoubtsPage({super.key});

  @override
  State<DoubtsPage> createState() => _DoubtsPageState();
}

class _DoubtsPageState extends State<DoubtsPage> {

  ValueNotifier<String> testLink = ValueNotifier<String>('');
  final DoubtsBloc doubtsBloc = DoubtsBloc();
  String? get errorText {
    final text = testLink.value;
    if(!Uri.parse(text).isAbsolute && text.isNotEmpty){
      return 'Enter valid Url';
    }else{
      return null;
    }
  }

  @override
  void initState(){
    super.initState();
    doubtsBloc.add(DoubtsInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DoubtsBloc, DoubtsState>(
      bloc: doubtsBloc,
      listener: (context, state) {},
      builder: (context, state) {
        switch (state.runtimeType){
          case DoubtsFetchingState:
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                title: SmallTextType(text: 'Doubts',size: getScreenWidth(context)*0.052),
              ),
              body: ListView.builder(
                  itemCount: 3,
                  itemBuilder: (context,index){
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: getScreenHeight(context)*0.015),
                      width: getScreenWidth(context),
                      child: Column(
                        spacing: getScreenHeight(context)*0.007,
                        children: [
                          SizedBox(
                            height: getScreenHeight(context)*0.025,
                            width: getScreenWidth(context),
                            child: Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: getScreenWidth(context)*0.03),
                                  decoration: const BoxDecoration(color: Colors.white),
                                )
                            ),
                          ),
                          SizedBox(
                            height: getScreenHeight(context)*0.008,
                            width: getScreenWidth(context),
                            child: Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: getScreenWidth(context)*0.03),
                                  decoration: const BoxDecoration(color: Colors.white),
                                )
                            ),
                          ),
                          SizedBox(
                            height: getScreenHeight(context)*0.008,
                            width: getScreenWidth(context),
                            child: Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: getScreenWidth(context)*0.03),
                                  decoration: const BoxDecoration(color: Colors.white),
                                )
                            ),
                          ),
                          SizedBox(
                            height: getScreenHeight(context)*0.18,
                            width: getScreenWidth(context),
                            child: Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: getScreenWidth(context)*0.03),
                                  decoration: const BoxDecoration(color: Colors.white),
                                )
                            ),
                          ),
                        ],
                      ),
                    );
                  }
              ),
            );
          case DoubtsLoadedSuccessState:
            final successState = state as DoubtsLoadedSuccessState;
            List<dynamic> tagsList = successState.tagsList;
            List<Map<String,dynamic>> doubtsList = successState.doubtsList;
            return RefreshIndicator(
              backgroundColor: Colors.white,
              color: slateGrayTagBorder,
              onRefresh: () async{
                doubtsBloc.add(DoubtsInitialEvent());
              },
              child: Scaffold(
                floatingActionButton: Stack(
                  children: [
                    Positioned(
                      bottom: getScreenHeight(context)*0.085,
                      right: getScreenWidth(context)*0.01,
                      child: FloatingActionButton.small(
                        onPressed: (){
                          TextEditingController linkController = TextEditingController();
                          TextEditingController titleController = TextEditingController();
                          TextEditingController bodyTextController = TextEditingController();
                          ValueNotifier<String> assetUrl= ValueNotifier<String>('');
                          ValueNotifier<String> titleValue = ValueNotifier<String>('');
                          List<String> selectedTagList = [];
                          List<int> indexList = [];
                          ValueNotifier<int> changingIndex = ValueNotifier<int>(0);
                          showModalBottomSheet(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              clipBehavior: Clip.hardEdge,
                              isScrollControlled: true,
                              context: context,
                              useSafeArea: true,
                              builder: (contexts){
                                late VideoPlayerController controller;
                                return Scaffold(
                                  resizeToAvoidBottomInset: false,
                                  backgroundColor: Colors.white,
                                  appBar: AppBar(
                                    backgroundColor: Colors.white,
                                    actions: <Widget>[
                                      ValueListenableBuilder(
                                          valueListenable: titleValue,
                                          builder: (context,_,__) {
                                            return GestureDetector(
                                              onTap: (){
                                                if(titleValue.value.isNotEmpty){
                                                  showDialog(
                                                      context: context,
                                                      builder: (context){
                                                        return Dialog(
                                                          backgroundColor: Colors.white,
                                                          clipBehavior: Clip.hardEdge,
                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                                          insetPadding: EdgeInsets.symmetric(horizontal: getScreenWidth(context)*0.15,vertical: getScreenHeight(context)*0.01),
                                                          child: Padding(
                                                            padding: EdgeInsets.symmetric(horizontal: getScreenWidth(context)*0.04),
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                Container(
                                                                  width: getScreenWidth(context),
                                                                  height: getScreenHeight(context)*0.45,
                                                                  color: Colors.white,
                                                                  child: ListView.builder(
                                                                      itemCount: tagsList.length,
                                                                      itemBuilder: (context,index){
                                                                        return ValueListenableBuilder(
                                                                            valueListenable: changingIndex,
                                                                            builder: (context,_,__) {
                                                                              return Container(
                                                                                padding: EdgeInsets.all(getScreenWidth(context)*0.01),
                                                                                color: indexList.contains(index)? forestGreenTagBackground:Colors.white,
                                                                                child: Row(
                                                                                  children: [
                                                                                    SmallTextType(text: tagsList[index]),
                                                                                    const Spacer(),
                                                                                    Checkbox(
                                                                                        value: indexList.contains(index),
                                                                                        activeColor: Colors.green,
                                                                                        onChanged: (values){
                                                                                          if(selectedTagList.contains(tagsList[index])){
                                                                                            selectedTagList.remove(tagsList[index]);
                                                                                            indexList.remove(index);
                                                                                            changingIndex.value++;
                                                                                          }else{
                                                                                            if(selectedTagList.length == 5){
                                                                                              Fluttertoast.showToast(
                                                                                                msg: "Max tags limit reached",
                                                                                                toastLength: Toast.LENGTH_SHORT,
                                                                                                gravity: ToastGravity.BOTTOM,
                                                                                                timeInSecForIosWeb: 1,
                                                                                                backgroundColor: Colors.red,
                                                                                                textColor: Colors.white,
                                                                                                fontSize: getScreenWidth(context)*0.045,
                                                                                              );
                                                                                            }else{
                                                                                              selectedTagList.add(tagsList[index]);
                                                                                              indexList.add(index);
                                                                                              changingIndex.value++;
                                                                                            }
                                                                                          }
                                                                                        }
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              );
                                                                            }
                                                                        );
                                                                      }),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets.all(getScreenWidth(context)*0.02),
                                                                  child: SimpleTextButton(onTap: () async{
                                                                    await DoubtsRepo.postNewDoubt(
                                                                        title: titleController.text,
                                                                        body: bodyTextController.text,
                                                                        asset: assetUrl.value,
                                                                        tags: selectedTagList);
                                                                    if(!context.mounted) return;
                                                                    Navigator.pop(context);
                                                                    Navigator.pop(contexts);
                                                                  },
                                                                    text: 'Submit',),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                  );
                                                }
                                              },
                                              child: Container(
                                                width: getScreenWidth(context)*0.17,
                                                height: getScreenHeight(context)*0.042,
                                                margin: EdgeInsets.only(right: getScreenWidth(context)*0.04),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    color: titleValue.value.isEmpty? primaryInnoColor.withAlpha(69): primaryInnoColor,
                                                    borderRadius: BorderRadius.circular(20),
                                                    border: Border.all(color: Colors.black,width: 0.5)
                                                ),
                                                child:const SmallTextType(text: 'Next',color: Colors.white,),
                                              ),
                                            );
                                          }
                                      )
                                    ],
                                    leading: SimpleChildButton(
                                        onTap: (){
                                          Navigator.pop(context);
                                        },
                                        child: const Icon(Icons.close)),
                                  ),
                                  body: SizedBox(
                                    height: getScreenHeight(context),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: getScreenWidth(context),
                                          child: TextField(
                                            controller: titleController,
                                            cursorColor: Colors.black,
                                            maxLines: null,
                                            keyboardType: TextInputType.multiline,
                                            autofocus: true,
                                            onChanged: (text)=>titleValue.value=text,
                                            onTapOutside: (event)=>FocusManager.instance.primaryFocus?.unfocus(),
                                            style: GoogleFonts.sourceSans3(fontSize:getScreenWidth(context)*0.058,color: const Color(0xff121A2C),fontWeight: FontWeight.w600),
                                            decoration: InputDecoration(
                                                floatingLabelBehavior: FloatingLabelBehavior.never,
                                                label: SmallTextType(text: 'Title',size: getScreenWidth(context)*0.058,),
                                                labelStyle: GoogleFonts.sourceSans3(fontSize:getScreenWidth(context)*0.058,color: const Color(0xff121A2C),fontWeight: FontWeight.w400),
                                                hintText: 'Title',
                                                hintStyle: GoogleFonts.sourceSans3(fontSize:getScreenWidth(context)*0.058,color: const Color(0xff121A2C),fontWeight: FontWeight.w600),
                                                enabledBorder: const OutlineInputBorder(
                                                  borderSide: BorderSide.none,),
                                                focusedBorder: const OutlineInputBorder(
                                                  borderSide: BorderSide.none,)
                                            ),
                                          ),
                                        ),
                                        ValueListenableBuilder(
                                            valueListenable: assetUrl,
                                            builder: (context,_,__){
                                              if(assetUrl.value.isNotEmpty) {
                                                switch (assetUrl.value.split(' ').first){
                                                  case 'img':
                                                    return Image.network(
                                                      assetUrl.value.split(' ').last,
                                                      width: getScreenWidth(context)*0.6,
                                                    );
                                                  case 'video':
                                                    ValueNotifier<int> videoStatus = ValueNotifier<int>(0);
                                                    controller = VideoPlayerController.networkUrl(Uri.parse(
                                                      assetUrl.value.split(' ').last,),
                                                      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
                                                    );
                                                    controller.addListener(() {
                                                      videoStatus.value++;
                                                    });
                                                    controller.setLooping(true);
                                                    controller.initialize();
                                                    return ValueListenableBuilder(
                                                        valueListenable: videoStatus,
                                                        builder: (context,_,__) {
                                                          return SizedBox(
                                                            width: getScreenWidth(context)*0.6,
                                                            child: controller.value.isInitialized?
                                                            AspectRatio(
                                                              aspectRatio: controller.value.aspectRatio,
                                                              child: Stack(
                                                                children: [
                                                                  VideoPlayer(controller),
                                                                  ControlsOverlay(controller: controller),
                                                                  VideoProgressIndicator(controller, allowScrubbing: true),
                                                                ],
                                                              ),
                                                            )
                                                                : const SizedBox(),
                                                          );
                                                        }
                                                    );
                                                  case 'link':
                                                    return SizedBox(
                                                      width: getScreenWidth(context),
                                                      child: SizedBox(
                                                        width: getScreenWidth(context),
                                                        child: ValueListenableBuilder(
                                                            valueListenable: testLink,
                                                            builder: (context,_,__) {
                                                              return TextField(
                                                                  cursorColor: Colors.black,
                                                                  controller:linkController,
                                                                  autofocus: true,
                                                                  decoration: InputDecoration(
                                                                      suffixIcon: SimpleChildButton(onTap: (){
                                                                        assetUrl.value='';
                                                                      }, child: const Icon(Icons.close)),
                                                                      floatingLabelBehavior: FloatingLabelBehavior.never,
                                                                      label: SmallTextType(text: 'Enter Link',size: getScreenWidth(context)*0.048,weight: FontWeight.w500,),
                                                                      hintText: 'Enter Link',
                                                                      errorText: errorText,
                                                                      labelStyle: GoogleFonts.sourceSans3(fontSize:getScreenWidth(context)*0.048,color: const Color(0xff121A2C),fontWeight: FontWeight.w500),
                                                                      enabledBorder: const OutlineInputBorder(
                                                                        borderSide: BorderSide.none,
                                                                      ),
                                                                      focusedBorder: const OutlineInputBorder(
                                                                        borderSide: BorderSide.none,
                                                                      )
                                                                  ),
                                                                  onChanged:(text){
                                                                    testLink.value = text;
                                                                  }
                                                              );
                                                            }
                                                        ),
                                                      ),
                                                    );
                                                  default:
                                                    return const SizedBox();
                                                }
                                              }else {
                                                return const SizedBox();
                                              }
                                            }),
                                        SizedBox(
                                          width: getScreenWidth(context),
                                          height: getScreenHeight(context)*0.7,
                                          child: SingleChildScrollView(
                                            child: TextField(
                                              controller: bodyTextController,
                                              cursorColor: Colors.black,
                                              keyboardType: TextInputType.multiline,
                                              maxLines: null,
                                              decoration: InputDecoration(
                                                  floatingLabelBehavior: FloatingLabelBehavior.never,
                                                  label: SmallTextType(text: 'body text (optional)',size: getScreenWidth(context)*0.048,weight: FontWeight.w500,),
                                                  labelStyle: GoogleFonts.sourceSans3(fontSize:getScreenWidth(context)*0.048,color: const Color(0xff121A2C),fontWeight: FontWeight.w500),
                                                  enabledBorder: const OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                  ),
                                                  focusedBorder: const OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                  )
                                              ),
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                        ValueListenableBuilder(
                                            valueListenable: assetUrl,
                                            builder: (context,_,__) {
                                              return SafeArea(
                                                child: Container(
                                                  margin: EdgeInsets.only(left: getScreenWidth(context)*0.06,bottom: getScreenHeight(context)*0.03),
                                                  width: getScreenWidth(context),
                                                  child: Row(
                                                    spacing: getScreenWidth(context)*0.05,
                                                    children: [
                                                      SimpleChildButton(
                                                        onTap:() async{
                                                          if(assetUrl.value.isEmpty) {
                                                            String value = await ProfileRepo
                                                                .selectImage(
                                                                'uploads/img', true);
                                                            if (value.isNotEmpty) {
                                                              assetUrl.value = 'img $value';
                                                            }
                                                          }
                                                        },
                                                        child: SizedBox(
                                                          height: getScreenHeight(context)*0.05,
                                                          width: getScreenHeight(context)*0.05,
                                                          child: Icon(Icons.image_outlined, size: getScreenWidth(context)*0.07,color: assetUrl.value.isEmpty? Colors.black:borderColor),
                                                        ),
                                                      ),
                                                      SimpleChildButton(
                                                        onTap:() async{
                                                          if(assetUrl.value.isEmpty){
                                                            String value = await ProfileRepo.selectVideo('uploads/video', true);
                                                            if(value.isNotEmpty){
                                                              assetUrl.value = 'video $value';
                                                            }
                                                          }
                                                        },
                                                        child: SizedBox(
                                                          height: getScreenHeight(context)*0.05,
                                                          width: getScreenHeight(context)*0.05,
                                                          child: Icon(Icons.ondemand_video_outlined, size: getScreenWidth(context)*0.07,color: assetUrl.value.isEmpty? Colors.black:borderColor),
                                                        ),
                                                      ),
                                                      SimpleChildButton(
                                                        onTap:(){
                                                          if(assetUrl.value.isEmpty) assetUrl.value = 'link';
                                                        },
                                                        child: SizedBox(
                                                          height: getScreenHeight(context)*0.05,
                                                          width: getScreenHeight(context)*0.05,
                                                          child: Icon(Icons.link_outlined, size: getScreenWidth(context)*0.07,color: assetUrl.value.isEmpty? Colors.black:borderColor,),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }
                          );
                        },
                        backgroundColor: const Color(0xffDCE6FA),
                        splashColor: const Color(0xff4169E1).withAlpha(60),
                        child: const Icon(Icons.add),
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.white,
                appBar: AppBar(
                  surfaceTintColor: Colors.white,
                  backgroundColor: Colors.white,
                  title: SmallTextType(text: 'Doubts',size: getScreenWidth(context)*0.052),
                ),
                body: ListView.builder(
                    // key: const PageStorageKey('pageStorageKey'),
                    itemCount: doubtsList.length,
                    shrinkWrap: true,
                    itemBuilder: (context,index){
                      return DoubtCardLarge(
                        doubt: doubtsList[index],
                      );
                    }),
              ),
            );
          default:
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                title: SmallTextType(text: 'Doubts',size: getScreenWidth(context)*0.052),
              ),
              body: Container(),
            );
        }
      },
);
  }
}