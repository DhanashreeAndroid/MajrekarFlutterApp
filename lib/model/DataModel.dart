import 'package:objectbox/objectbox.dart';
import 'dart:convert';

DataModel authModelFromJson(String str) => DataModel.fromJson(json.decode(str));

String authModelToJson(DataModel data) => json.encode(data.toJson());

class DataModel {
  List<EDetails>? eDetails;

  DataModel({this.eDetails});

  DataModel.fromJson(Map<String, dynamic> json) {
    if (json['eDetails'] != null) {
      eDetails = <EDetails>[];
      json['eDetails'].forEach((v) {
        eDetails!.add(EDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (eDetails != null) {
      data['eDetails'] = eDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
@Entity()
class EDetails {
  @Id()
  int? id;
  String? dbId;
  String? wardNo;
  String? partNo;
  String? serialNo;
  String? cardNo;
  String? lnEnglish;
  String? fnEnglish;
  String? lnMarathi;
  String? fnMarathi;
  String? sex;
  String? age;
  String? houseNoEnglish;
  String? houseNoMarathi;
  String? buildingNameEnglish;
  String? buildingNameMarathi;
  String? boothAddressEnglish;
  String? boothAddressMarathi;
  String? lang;
  String? color;
  String? shiftedDeath;
  String? votedNonVoted;

  EDetails(
      {
        this.id,
        this.dbId,
        this.wardNo,
        this.partNo,
        this.serialNo,
        this.cardNo,
        this.lnEnglish,
        this.fnEnglish,
        this.lnMarathi,
        this.fnMarathi,
        this.sex,
        this.age,
        this.houseNoEnglish,
        this.houseNoMarathi,
        this.buildingNameEnglish,
        this.buildingNameMarathi,
        this.boothAddressEnglish,
        this.boothAddressMarathi,
        this.lang,
        this.color,
        this.shiftedDeath,
        this.votedNonVoted      });

  EDetails.fromJson(Map<String, dynamic> json) {

    dbId                  = json['Id'].toString();
    wardNo                = json['WardNo'];
    partNo                = json['PartNo'];
    serialNo              = json['SerialNo'];
    cardNo                = json['CardNo'];
    lnEnglish             = json['LN_English'];
    fnEnglish             = json['FN_English'];
    lnMarathi             = json['LN_Marathi'];
    fnMarathi             = json['FN_Marathi'];
    sex                   = json['Sex'];
    age                   = json['Age'];
    houseNoEnglish        = json['HouseNo_English'];
    houseNoMarathi        = json['HouseNo_Marathi'];
    buildingNameEnglish   = json['BuildingName_English'];
    buildingNameMarathi   = json['BuildingName_marathi'];
    boothAddressEnglish   = json['EnglishBoothAddress'];
    boothAddressMarathi   = json['MarathiBoothAddress'];
    lang                  = json['Lang'];
    color                 = json['Color'];
    shiftedDeath          = json['Shifted_Death'];
    votedNonVoted         = json['Voted_NonVoted'];


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id']= dbId;
    data['WardNo']= wardNo;
    data['PartNo']=partNo;
    data['SerialNo']=serialNo;
    data['CardNo']=cardNo;
    data['LN_English']=lnEnglish;
    data['FN_English']=fnEnglish;
    data['LN_Marathi']=lnMarathi;
    data['FN_Marathi']=fnMarathi;
    data['Sex']=sex;
    data['Age']=age;
    data['HouseNo_English']=houseNoEnglish;
    data['HouseNo_Marathi']=houseNoMarathi;
    data['BuildingName_English']=buildingNameEnglish;
    data['BuildingName_marathi']=buildingNameMarathi;
    data['EnglishBoothAddress']=boothAddressEnglish;
    data['MarathiBoothAddress']=boothAddressMarathi;
    data['Lang']=lang;
    data['Color']=color;
    data['Shifted_Death']=shiftedDeath;
    data['Voted_NonVoted']=votedNonVoted;
    return data;
  }
}