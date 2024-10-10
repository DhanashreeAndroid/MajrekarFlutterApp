import 'package:floor/floor.dart';

@entity
class MainData {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String? dbId;
  final String? wardNo;
  final String? partNo;
  final String? serialNo;
  final String? cardNo;
  final String? lnEnglish;
  final String? fnEnglish;
  final String? lnMarathi;
  final String? fnMarathi;
  final String? sex;
  final String? age;
  final String? houseNoEnglish;
  final String? houseNoMarathi;
  final String? buildingNameEnglish;
  final String? buildingNameMarathi;
  final String? boothAddressEnglish;
  final String? boothAddressMarathi;
  final String? lang;
  final String? color;
  final String? shiftedDeath;
  final String? votedNonVoted;

  MainData(this.id, this.dbId,this.wardNo, this.partNo, this.serialNo, this.cardNo, this.lnEnglish, this.fnEnglish,
      this.lnMarathi, this.fnMarathi, this.sex, this.age, this.houseNoEnglish, this.houseNoMarathi,
      this.buildingNameEnglish, this.buildingNameMarathi, this.boothAddressEnglish, this.boothAddressMarathi,
      this.lang, this.color, this.shiftedDeath, this.votedNonVoted );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MainData &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          dbId == other.dbId &&
          wardNo == other.wardNo &&
          partNo == other.partNo &&
          serialNo == other.serialNo &&
          cardNo == other.cardNo &&
          lnEnglish == other.lnEnglish &&
          fnEnglish == other.fnEnglish &&
          lnMarathi == other.lnMarathi &&
          fnMarathi == other.fnMarathi &&
          sex == other.sex &&
          age == other.age &&
          houseNoEnglish == other.houseNoEnglish &&
          houseNoMarathi == other.houseNoMarathi &&
          buildingNameEnglish == other.buildingNameEnglish &&
          buildingNameMarathi == other.buildingNameMarathi &&
          boothAddressEnglish == other.boothAddressEnglish &&
          boothAddressMarathi == other.boothAddressMarathi &&
          lang == other.lang &&
          color == other.color &&
          shiftedDeath == other.shiftedDeath &&
          votedNonVoted == other.votedNonVoted;

  @override
  int get hashCode => id.hashCode ^ dbId.hashCode ^ wardNo.hashCode ^
  partNo.hashCode ^ serialNo.hashCode ^ cardNo.hashCode ^
  lnEnglish.hashCode ^ fnEnglish.hashCode ^ lnMarathi.hashCode ^
  fnMarathi.hashCode ^ sex.hashCode ^ age.hashCode ^
  houseNoMarathi.hashCode ^ houseNoEnglish.hashCode ^ buildingNameEnglish.hashCode ^
  buildingNameMarathi.hashCode ^ boothAddressEnglish.hashCode ^ boothAddressMarathi.hashCode ^
  lang.hashCode ^ color.hashCode ^ shiftedDeath.hashCode ^
  votedNonVoted.hashCode  ;

  @override
  String toString() {
    return 'MainData{id: $id, dbId: $dbId, wardNo: $wardNo, partNo: $partNo, serialNo: $serialNo, cardNo: $cardNo}';
  }

  MainData copyWith({
    int? id,
    String? dbId,
    String? wardNo,
    String? partNo,
    String? serialNo,
    String? cardNo,
    String? lnEnglish,
    String? fnEnglish,
    String? lnMarathi,
    String? fnMarathi,
    String? sex,
    String? age,
    String? houseNoEnglish,
    String? houseNoMarathi,
    String? buildingNameEnglish,
    String? buildingNameMarathi,
    String? boothAddressEnglish,
    String? boothAddressMarathi,
    String? lang,
    String? color,
    String? shiftedDeath,
    String? votedNonVoted
  }) {
    return MainData(
      id ?? this.id,
      dbId ?? this.dbId,
      wardNo ?? this.wardNo,
      partNo ?? this.partNo,
      serialNo ?? this.serialNo,
      cardNo ?? this.cardNo,
      lnEnglish ?? this.lnEnglish,
      fnEnglish ?? this.fnEnglish,
      lnMarathi ?? this.lnMarathi,
      fnMarathi ?? this.fnMarathi,
      sex ?? this.sex,
      age ?? this.age,
      houseNoEnglish ?? this.houseNoEnglish,
      houseNoMarathi ?? this.houseNoMarathi,
      buildingNameEnglish ?? this.buildingNameEnglish,
      buildingNameMarathi ?? this.buildingNameMarathi,
      boothAddressEnglish ?? this.boothAddressEnglish,
      boothAddressMarathi ?? this.boothAddressMarathi,
      lang ?? this.lang,
      color ?? this.color,
      shiftedDeath ?? this.shiftedDeath,
      votedNonVoted ?? this.votedNonVoted
    );
  }
}
