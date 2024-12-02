import 'dart:convert';

class StudentDataModel {
  final String name;
  final String email;
  final String collegeMail;
  final String gender;
  final String branch;
  final bool isHosteller;
  final String address;
  final String mobileNumber;
  final String lib;
  final String description;
  final bool fee;

  StudentDataModel(
      {
       required this.name,
       required this.email,
       required this.collegeMail,
       required this.gender,
       required this.branch,
       required this.isHosteller,
       required this.address,
       required this.mobileNumber,
       required this.lib,
       required this.description,
       required this.fee});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
    'name' : name,
    'email' :email,
    'collegeMail' :collegeMail,
    'gender' :gender,
    'branch' :branch,
    'isHosteller' :isHosteller,
    'address' :address,
    'mobileNumber' :mobileNumber,
    'lib' :lib,
    'description' :description,
    'fee' :fee
    };
  }

  factory StudentDataModel.fromMap(Map<String, dynamic> data) {
    return StudentDataModel(
    name: (data['name'])!=null?data['name'] as String:'' ,
    email: (data['email'])!=null?data['email']as String:'',
    collegeMail: (data['collegeMail'])!=null?data['collegeMail']as String:'' ,
    gender: (data['gender'])!=null?data['gender']as String:'' ,
    branch: (data['branch'])!=null?data['branch']as String:'',
    isHosteller: (data['isHosteller'])!=null?data['isHosteller']as bool:false ,
    address: (data['address'])!=null?data['address']as String:'' ,
    mobileNumber: (data['mobileNumber'])!=null?data['mobileNumber']as String:'' ,
    lib: (data['lib'])!=null?data['lib']as String:'' ,
    description: (data['description'])!=null?data['description']as String:'',
    fee: (data['fee'])!=null?data['fee']as bool:false ,
    );
  }

  String toJson() => json.encode(toMap());

  factory StudentDataModel.fromJson(String source) =>
      StudentDataModel.fromMap(json.decode(source) as Map<String, dynamic>);

}
