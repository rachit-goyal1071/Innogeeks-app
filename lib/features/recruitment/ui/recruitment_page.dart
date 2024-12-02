import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innogeeks_app/constants/dimensions.dart';
import 'package:innogeeks_app/constants/fonts.dart';
import 'package:innogeeks_app/features/recruitment/bloc/recruitment_bloc.dart';
import 'package:innogeeks_app/features/recruitment/repo/recruitment_repo.dart';
import 'package:innogeeks_app/features/recruitment/ui/student_data_card.dart';
import 'package:innogeeks_app/models/student_data_model.dart';

class RecruitmentPage extends StatefulWidget {
  const RecruitmentPage({super.key});

  @override
  State<RecruitmentPage> createState() => _RecruitmentPageState();
}

class _RecruitmentPageState extends State<RecruitmentPage> {

  RecruitmentBloc recruitmentBloc = RecruitmentBloc();

  @override
  void initState(){
    super.initState();
    recruitmentBloc.add(RecruitmentInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RecruitmentBloc, RecruitmentState>(
        bloc: recruitmentBloc,
        listener: (context, state) {},
        builder: (context, state) {
          switch (state.runtimeType){
            case RecruitmentFetchingState:
              return Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    backgroundColor: Colors.white,
                    title: SmallTextType(text: 'Recruitment Management',
                      size: getScreenWidth(context) * 0.05,),
                  ),
                  body: const Center(child: CircularProgressIndicator(color: Colors.blue,),));
            case RecruitmentLoadedSuccessState:
              final successState = state as RecruitmentLoadedSuccessState;
              return Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  title:
                  SmallTextType(text: 'Recruitment Management',
                    size: getScreenWidth(context) * 0.05,),
                  // Typeahe
                  actions: [
                    IconButton(onPressed: (){
                      RecruitmentRepo.convertMapToList(successState.dataUserDetailsList);
                    }, icon: const Icon(Icons.save_alt))
                  ],
                ),
                body: ListView.builder(
                  itemCount: successState.dataIdList.length,
                    itemBuilder: (context,index) {
                      return StudentDataCard(userId: successState.dataIdList[index], userDetails: successState.dataUserDetailsList[index]);
                    }
                ),
              );
            default:
              return Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    backgroundColor: Colors.white,
                    title: SmallTextType(text: 'Recruitment Management',
                      size: getScreenWidth(context) * 0.05,),
                  ),
                  body: const Center(child: CircularProgressIndicator(color: Colors.green,),));
          }
        },
      );
  }
}
