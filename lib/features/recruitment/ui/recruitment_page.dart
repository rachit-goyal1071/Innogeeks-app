import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innogeeks_app/constants/dimensions.dart';
import 'package:innogeeks_app/constants/fonts.dart';
import 'package:innogeeks_app/features/recruitment/bloc/recruitment_bloc.dart';
import 'package:innogeeks_app/features/recruitment/repo/recruitment_repo.dart';
import 'package:innogeeks_app/features/recruitment/ui/student_data_card.dart';
import 'package:innogeeks_app/features/widgets/widgets.dart';
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

  SingleValueDropDownController sortController = SingleValueDropDownController(
      data: const DropDownValueModel(name: 'Sort by:', value: '')
  );

  List<StudentDataModel> dataList = [];

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
              if(successState.isInitial){
                dataList=successState.dataUserDetailsList;
              }
              return Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  title:
                  SmallTextType(text: 'Recruitment Management',
                    size: getScreenWidth(context) * 0.05,),
                  actions: [
                    IconButton(onPressed: (){
                      showDialog(context: context,
                          builder: (context){
                            return Dialog(
                              backgroundColor: Colors.white,
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: getScreenWidth(context)*0.05,vertical: getScreenHeight(context)*0.05),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width:getScreenWidth(context)*0.49,
                                      child: DropDownTextField(
                                        controller: sortController,
                                          dropDownList: const [
                                            DropDownValueModel(name: 'Name',value: 'name'),
                                            DropDownValueModel(name: 'Library Id', value: 'lib'),
                                            DropDownValueModel(name: 'CSE', value: 'branch/CSE'),
                                            DropDownValueModel(name: 'CS', value: 'branch/CS'),
                                            DropDownValueModel(name: 'IT', value: 'branch/IT'),
                                            DropDownValueModel(name: 'CSIT', value: 'branch/CSIT'),
                                            DropDownValueModel(name: 'CSE(AIML)', value: 'branch/CSEAIML'),
                                            DropDownValueModel(name: 'CSEAI', value: 'branch/CSEAI'),
                                            DropDownValueModel(name: 'ELCE', value: 'branch/ELCE'),
                                            DropDownValueModel(name: 'ECE', value: 'branch/ECE'),
                                            DropDownValueModel(name: 'EN/EEE', value: 'branch/EN'),
                                            DropDownValueModel(name: 'ME', value: 'branch/ME'),
                                      ]),
                                    ),
                                    SizedBox(height: getScreenHeight(context)*0.02,),
                                    SimpleTextButton(text: 'Sort', onTap: (){
                                      recruitmentBloc.add(RecruitmentSortingEvent(
                                          dataModel: dataList,
                                          sortBy: sortController.dropDownValue!.value.toString(),
                                          dataIdList: successState.dataIdList));
                                      Navigator.pop(context);
                                    })
                                  ],
                                ),
                              ),
                            );
                          }
                      );
                    }, icon: const Icon(Icons.sort)),
                    IconButton(onPressed: (){
                      RecruitmentRepo.convertMapToList(successState.dataUserDetailsList);
                    }, icon: const Icon(Icons.save_alt))
                  ],
                ),
                body: ListView.builder(
                  itemCount: successState.dataUserDetailsList.length,
                    itemBuilder: (context,index) {
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: getScreenHeight(context)*0.005),
                          child: StudentDataCard(userId: successState.dataIdList[index], userDetails: successState.dataUserDetailsList[index]));
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
