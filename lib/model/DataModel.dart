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
    wardNo                = json['wardno'];
    partNo                = json['partno'];
    serialNo              = json['serialno'];
    cardNo                = json['cardno'];
    lnEnglish             = json['ln_english'];
    fnEnglish             = json['fn_english'];
    lnMarathi             = json['ln_marathi'];
    fnMarathi             = json['fn_marathi'];
    sex                   = json['sex'];
    age                   = json['age'];
    houseNoEnglish        = json['houseno_english'];
    houseNoMarathi        = json['houseno_marathi'];
    buildingNameEnglish   = json['buildingname_english'];
    buildingNameMarathi   = json['buildingname_marathi'];
    boothAddressEnglish   = json['english_booth_address'];
    boothAddressMarathi   = json['marathi_booth_address'];
    lang                  = json['lang'];
    color                 = json['color'];
    shiftedDeath          = json['shifted_death'];
    votedNonVoted         = json['voted_nonvoted'];


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id']= dbId;
    data['wardno']= wardNo;
    data['partno']=partNo;
    data['serialno']=serialNo;
    data['cardno']=cardNo;
    data['ln_english']=lnEnglish;
    data['fn_english']=fnEnglish;
    data['ln_marathi']=lnMarathi;
    data['fn_marathi']=fnMarathi;
    data['sex']=sex;
    data['age']=age;
    data['houseno_english']=houseNoEnglish;
    data['houseno_marathi']=houseNoMarathi;
    data['buildingname_english']=buildingNameEnglish;
    data['buildingname_marathi']=buildingNameMarathi;
    data['english_booth_address']=boothAddressEnglish;
    data['marathi_booth_address']=boothAddressMarathi;
    data['lang']=lang;
    data['color']=color;
    data['shifted_death']=shiftedDeath;
    data['voted_nonvoted']=votedNonVoted;
    return data;
  }

  @override
  String toString() {
    return '{dbId: ${dbId}, wardno: ${wardNo}, lnName: ${lnEnglish}, fnName: ${fnEnglish}}';
  }
}