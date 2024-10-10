
import 'dart:convert';

VidhansabhaModel authModelFromJson(String str) => VidhansabhaModel.fromJson(json.decode(str));

String authModelToJson(VidhansabhaModel data) => json.encode(data.toJson());

class VidhansabhaModel {
  List<Vidhansabha>? vidhansabhaList;

  VidhansabhaModel({this.vidhansabhaList});

  VidhansabhaModel.fromJson(Map<String, dynamic> json) {
    if (json['boothlst'] != null) {
      vidhansabhaList = <Vidhansabha>[];
      json['boothlst'].forEach((v) {
        vidhansabhaList!.add(Vidhansabha.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (vidhansabhaList != null) {
      data['boothlst'] = vidhansabhaList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Vidhansabha {

  int? id;
  String? dbId;
  String? wardNo;
  String? partNo;
  String? from;
  String? to;

  String? boothAddressEnglish;

  String? boothAddressMarathi;

  Vidhansabha(
      {
        this.id,
        this.dbId,
        this.wardNo,
        this.partNo,
        this.from,
        this.to,
        this.boothAddressEnglish,
        this.boothAddressMarathi  });

  Vidhansabha.fromJson(Map<String, dynamic> json) {

    dbId                  = json['id'].toString();
    wardNo                = json['wardno'];
    partNo                = json['partno'];
    from              = json['from'];
    to                = json['to'];
    boothAddressEnglish   = json['english_booth_address'];
    boothAddressMarathi   = json['marathi_booth_address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id']= dbId;
    data['wardno']= wardNo;
    data['partno']=partNo;
    data['from']=from;
    data['to']=to;
    data['english_booth_address']=boothAddressEnglish;
    data['marathi_booth_address']=boothAddressMarathi;
    return data;
  }

  @override
  String toString() {
    return '{partno: ${partNo}, wardno: ${wardNo}, from: ${from}, to: ${to}, english_booth_address: ${boothAddressEnglish}, marathi_booth_address: ${boothAddressMarathi}}';
  }
}