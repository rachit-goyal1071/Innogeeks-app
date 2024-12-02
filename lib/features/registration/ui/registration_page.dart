import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innogeeks_app/constants/dimensions.dart';
import 'package:innogeeks_app/constants/fonts.dart';
import 'package:innogeeks_app/features/registration/bloc/registration_bloc.dart';
import 'package:innogeeks_app/features/registration/repo/razorpay_api.dart';
import 'package:innogeeks_app/features/registration/repo/registration_repo.dart';
import 'package:innogeeks_app/features/widgets/text_field.dart';
import 'package:innogeeks_app/features/widgets/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../constants/razorpay_key.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController collegeEmailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController libController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  SingleValueDropDownController genderController = SingleValueDropDownController(
    data: const DropDownValueModel(name: 'Select Gender', value: '')
  );
  SingleValueDropDownController branchController = SingleValueDropDownController(
      data: const DropDownValueModel(name: 'Branch', value: '')
  );
  TextEditingController residenceController = TextEditingController();
  ValueNotifier<bool> isHosteller = ValueNotifier<bool>(false);
  var _razorpay;
  RegistrationBloc registrationBloc = RegistrationBloc();

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    if(kDebugMode){
      print('Payment success');
    }
    registrationBloc.add(PaymentSuccessfulEvent());
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    if (kDebugMode) {
      print('error ${response.error}');
    }
    openErrorSnackBar(context, 'Payment Failed: ${response.error}');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    if(kDebugMode){
      print('wallet ${response.walletName}');
    }
  }

  @override
  void initState(){
    super.initState();
    registrationBloc.add(InitialRegistrationEvent());
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: SmallTextType(text: 'Register',size: getScreenWidth(context)*0.05,),
      ),
      body: BlocConsumer<RegistrationBloc, RegistrationState>(
        bloc: registrationBloc,
        listenWhen: (previous,current)=> current is RegistrationActionState,
        buildWhen: (previous,current)=> current is! RegistrationActionState,
        listener: (context, state) async{
          if(state is NewCandidateRegisteredState){
            showDialog(
                context: context,
                builder: (context){
                  return Lottie.asset('assets/gif/verified.json');
                },
              useRootNavigator: false
            );
            await Future.delayed(const Duration(seconds: 2),()=> registrationBloc.add(MoveToCandidateFeePaymentPage())).then((_){
              Navigator.pop(context);
            });
          }
      },
        builder: (context, state) {
          switch (state.runtimeType){
            case RegistrationFetchingState:
              return const Center(child: CircularProgressIndicator(color: Colors.blue,),);
            case RegistrationErrorState:
              return Center(child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xffD61E11),
                  ),
                  child: Lottie.asset('assets/gif/caution.json',)),);
            case RegistrationLoadedSuccessState:
              final successState = state as RegistrationLoadedSuccessState;
              nameController.text = successState.data['firstName'] + ' ' + successState.data['lastName'];
              emailController.text = successState.data['email'];
              phoneController.text = successState.data['mobileNumber'];
              libController.text = successState.data['lib'];
              return SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: getScreenWidth(context)*0.02,vertical: getScreenHeight(context)*0.02),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      DetailsTextField(controller: nameController, label: 'Full Name'),
                      DetailsTextField(controller: emailController, label: 'Email'),
                      DetailsTextField(controller: collegeEmailController, label: 'College Email',icon: IconButton(onPressed: (){},icon: const Icon(Icons.info_outline)),),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: getScreenWidth(context)*0.08),
                        child: DropDownTextField(
                          dropDownList: const [
                            DropDownValueModel(name: 'Male', value: 'Male'),
                            DropDownValueModel(name: 'Female', value: 'Female'),
                            DropDownValueModel(name: 'Others', value: 'Others'),
                          ],
                          controller: genderController,),
                      ),
                      SizedBox(height: getScreenHeight(context)*0.01,),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: getScreenWidth(context)*0.08),
                        child: DropDownTextField(
                          dropDownList: const [
                            DropDownValueModel(name: 'CSE', value: 'CSE'),
                            DropDownValueModel(name: 'CS', value: 'CS'),
                            DropDownValueModel(name: 'IT', value: 'IT'),
                            DropDownValueModel(name: 'CSIT', value: 'CSIT'),
                            DropDownValueModel(name: 'CSE(AIML)', value: 'CSEAIML'),
                            DropDownValueModel(name: 'CSEAI', value: 'CSEAI'),
                            DropDownValueModel(name: 'ELCE', value: 'ELCE'),
                            DropDownValueModel(name: 'ECE', value: 'ECE'),
                            DropDownValueModel(name: 'EN/EEE', value: 'EN'),
                            DropDownValueModel(name: 'ME', value: 'ME'),
                          ],
                          controller: branchController,),
                      ),
                      ValueListenableBuilder(
                        valueListenable: isHosteller,
                        builder: (context,_,__) {
                          return Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(width: getScreenWidth(context)*0.035,),
                                  Checkbox(
                                    activeColor: Colors.green,
                                      value: isHosteller.value,
                                      onChanged: (value){
                                        isHosteller.value = value!;
                                      }),
                                  const SmallTextType(text: 'KIET Hosteller ?')
                                ],
                              ),
                              DetailsTextField(controller: residenceController, label: isHosteller.value? 'Hostel Name':'Current Address'),
                            ],
                          );
                        }
                      ),
                      DetailsTextField(controller: phoneController, label: 'Phone Number',clickable: false,),
                      DetailsTextField(controller: libController, label: 'Lib ID',clickable: false,),
                      DetailsTextField(controller: descriptionController, label: 'Tell us More about yourself'),
                      SizedBox(height: getScreenHeight(context)*0.01,),
                      Center(child: SimpleTextButton(onTap: () async{
                        await RegistrationRepo.registerNewCandidate(
                            name: nameController.text,
                            email: emailController.text,
                            collegeMail: collegeEmailController.text,
                            gender: genderController.dropDownValue!.value,
                            branch: branchController.dropDownValue!.value,
                            isHosteller: isHosteller.value,
                            address: residenceController.text,
                            mobileNumber: phoneController.text,
                            lib: libController.text,
                            description: descriptionController.text);
                        registrationBloc.add(CandidateRegisteredEvent());
                      }, text: 'Submit',width: 0.5,)),
                      SizedBox(height: getScreenHeight(context)*0.04,),
                    ],
                  ),
                ),
              );
            case RegisteredCandidateFeePaymentState:
              final successState = state as RegisteredCandidateFeePaymentState;
              final feeStatus = successState.data['fee'];
              int feeValue = int.parse(successState.feeAmount);
              return Container(
                margin: EdgeInsets.symmetric(horizontal: getScreenWidth(context)*0.02),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: kElevationToShadow[1],
                ),
                child: !feeStatus?
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: SmallTextType(text: 'Registration Details',size: getScreenWidth(context)*0.053,)),
                    SmallTextType(text: 'Name: ${successState.data['name']}'),
                    SmallTextType(text: 'Personal Mail: ${successState.data['name']}'),
                    SmallTextType(text: 'College Mail: ${successState.data['name']}'),
                    SmallTextType(text: 'Gender: ${successState.data['name']}'),
                    SmallTextType(text: 'Branch: ${successState.data['name']}'),
                    SmallTextType(text: (successState.data['isHosteller'])?'Hosteller':'Day Scholar'),
                    SmallTextType(text: 'Address: ${successState.data['address']}'),
                    SmallTextType(text: 'Contact Number: ${successState.data['mobileNumber']}'),
                    SmallTextType(text: 'Library ID: ${successState.data['lib']}'),
                    Flexible(child: SmallTextType(text: 'About Me: ${successState.data['description']}',overflow: TextOverflow.visible,)),
                    SmallTextType(text: 'Fee Status: ₹${successState.feeAmount} Pending'),
                    SizedBox(height: getScreenHeight(context)*0.02,),
                    Center(
                      child: SimpleTextButton(onTap: () async{
                        final order_id = await RazorpayAPI.createRazorpayOrder(amount: feeValue);
                        if(kDebugMode){
                          print(order_id.toString());
                        }
                        Razorpay razorpay = Razorpay();
                        var options = {
                          'key':key,
                          'amount':50,
                          'name':'App Innogeeks',
                          'order_id':order_id,
                          'retry':{'enabled': true, 'max_count': 1},
                          'send_sms_hash': true,
                          'prefill': {'contact': successState.data['mobileNumber'], 'email': successState.data['mail']},
                          'external': {
                            'wallets': ['paytm']
                          }
                        };
                        razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
                        razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
                        razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
                        razorpay.open(options);
                      }, text: 'Final Submit',),
                    )
                  ],
                ):const Center(
                  child: SizedBox(
                    child: SmallTextType(text: 'Registration Completed: Wait for the Update'),
                  ),
                )
              );
            default :
              return const Center(child: CircularProgressIndicator(color: Colors.red,),);
          }
      },
    ),
    );
  }
}
