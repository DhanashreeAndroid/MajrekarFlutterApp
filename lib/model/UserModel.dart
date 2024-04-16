import 'package:objectbox/objectbox.dart';
import 'dart:convert';

UserModel authModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String authModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  List<UserDetails>? uDetails;

  UserModel({this.uDetails});

  UserModel.fromJson(Map<String?, dynamic> json) {
    if (json['user'] != null) {
      uDetails = <UserDetails>[];
      uDetails!.add(UserDetails.fromJson(json['user']));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (uDetails != null) {
      data['user'] = uDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
@Entity()
class UserDetails {
  @Id()
  int? id;
  String? userName;
  String? userRole;
  String? userEmail;
  String? password;
  String? vidhansabhaName;
  String? isUpdatable;
  String? isMarkable;
  String? isVotingMakingReport;
  String? isContactReport;
  String? electionDate;
  String? time;
  String? lineForOnlyPrintingPurpose;
  String? smsTimeLimit;
  String? macAddress;

  UserDetails(
      {
        this.id,
        this.userName,
        this.userRole,
        this.userEmail,
        this.password,
        this.vidhansabhaName,
        this.isUpdatable,
        this.isMarkable,
        this.isVotingMakingReport,
        this.isContactReport,
        this.electionDate,
        this.time,
        this.lineForOnlyPrintingPurpose,
        this.smsTimeLimit ,
      this.macAddress});

  UserDetails.fromJson(Map<String, dynamic> json) {

    userName               = json['userid'].toString().isEmpty? "0" : json['userid'];
    userRole               = json['userrole'].toString().isEmpty? "0" : json['userrole'];
    userEmail              = json['useremail'].toString().isEmpty? "0" : json['useremail'];
    vidhansabhaName          = json['vidhansabhaName'].toString().isEmpty? "0" : json['vidhansabhaName'];
    isUpdatable            = json['isUpdatable'].toString();
    isMarkable             = json['isMarkable'].toString();
    isVotingMakingReport   = json['isVotingMakingReport'].toString();
    isContactReport        = json['isContactReport'].toString();
    electionDate           = json['electionDate'].toString().isEmpty? "0" : json['electionDate'];
    time                   = json['time'].toString().isEmpty? "0" : json['time'];
    lineForOnlyPrintingPurpose  = json['lineForOnlyPrintingPurpose'].toString().isEmpty? "0" : json['lineForOnlyPrintingPurpose'];
    smsTimeLimit                = json['smsTimeLimit'].toString().isEmpty? "0" : json['smsTimeLimit'];
    macAddress                = json['macAddress'].toString().isEmpty? "0" : json['macAddress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userid']= userName;
    data['userrole']= userRole;
    data['useremail']= userEmail;
    data['vidhansabhaName']= vidhansabhaName;
    data['isUpdatable']= isUpdatable;
    data['isMarkable']=isMarkable;
    data['isVotingMakingReport']=isVotingMakingReport;
    data['isContactReport']=isContactReport;
    data['electionDate']=electionDate;
    data['time']=time;
    data['lineForOnlyPrintingPurpose']=lineForOnlyPrintingPurpose;
    data['smsTimeLimit']=smsTimeLimit;
    data['macAddress']=macAddress;
    return data;
  }

  @override
  String toString() {
    return '{userName: ${userName}, password: ${password}, vidhansabhaName: ${vidhansabhaName}, isUpdatable: ${isUpdatable}}';
  }
}