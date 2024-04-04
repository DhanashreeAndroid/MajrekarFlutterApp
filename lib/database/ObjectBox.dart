import 'package:flutter/foundation.dart';
import 'package:majrekar_app/menu_pages/ageWiseReport/age_count_model.dart';
import 'package:majrekar_app/menu_pages/languageSearch/language_list_model.dart';
import 'package:objectbox/objectbox.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:majrekar_app/model/DataModel.dart';
import 'package:majrekar_app/objectbox.g.dart';

import '../menu_pages/buildingWiseSearch/partno_drop_list_model.dart';
import '../menu_pages/surname_counter_model.dart';
import '../model/UserModel.dart';
import '../model/VidhansabhaModel.dart';

class ObjectBox {

  late final Store store;


  ObjectBox._create(this.store) {

  }
  static Future<ObjectBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();

    final store = await openStore(directory: p.join(docsDir.path, "obx-example"));
    return ObjectBox._create(store);
  }

  static Future<int> insert(EDetails person) async {
    final store = await openStore();
    var box = store.box<EDetails>();
    var output = box.put(person);
    store.close();
    return output;
  }
  static Future<List<int>> insertAll(List<EDetails> person) async {
    final store = await openStore();
    var box = store.box<EDetails>();
    var output =box.putMany(person);
    store.close();
    return output;
  }

  static Future<bool> delete(int id) async {
    final store = await openStore();
    var box = store.box<EDetails>();
    var output =box.remove(id);
    store.close();
    return output;
  }

  static Future<int> deleteAll() async {
    final store = await openStore();
    var box = store.box<EDetails>();
    var output = box.removeAll();
    store.close();
    return output;
  }

  static Future<EDetails?> queryPerson(int id) async {
    final store = await openStore();
    var box = store.box<EDetails>();
    var output = box.get(id);
    store.close();
    return output;
  }

  static Future<bool> isDataAvailable() async {
    final store = await openStore();
    var box = store.box<Vidhansabha>();
    store.close();
    if(box.isEmpty()){
      return false;
    }else{
      return true;
    }
  }

  static Future<List<EDetails>> getAll(String searchType) async {
    final store = await openStore();
    var box = store.box<EDetails>();

    if(searchType.contains("Name")){
      final query  = (box.query(EDetails_.fnEnglish.notEquals(''))..order(EDetails_.fnEnglish, flags:  Order.nullsLast )).build();
      final output = query.find();
      query.close();
      store.close();
      return output;
    }else{
      final query  = (box.query(EDetails_.lnEnglish.notEquals(''))..order(EDetails_.lnEnglish, flags:  Order.nullsLast )).build();
      final output = query.find();
      query.close();
      store.close();
      return output;
    }


  }

  static Future<List<EDetails>> getSearchResult(String searchType, String search) async {
    final store = await openStore();
    var box = store.box<EDetails>();

    if(searchType.contains("Name")){
      final query  = (box.query(EDetails_.fnEnglish.notEquals('') &
      EDetails_.lnEnglish.contains(search, caseSensitive: false) |
          EDetails_.fnEnglish.contains(search, caseSensitive: false) )..order(EDetails_.fnEnglish, flags:  Order.nullsLast )).build();
      final output = query.find();
      query.close();
      store.close();
      return output;
    }else{
      final query  = (box.query(EDetails_.lnEnglish.notEquals('') &
      EDetails_.lnEnglish.contains(search, caseSensitive: false) |
      EDetails_.fnEnglish.contains(search, caseSensitive: false))..order(EDetails_.lnEnglish, flags:  Order.nullsLast )).build();
      final output = query.find();
      query.close();
      store.close();
      return output;
    }


  }


  static Future<List<EDetails>> getAllBuildingWiseData(String buildingName) async {
    final store = await openStore();
    var box = store.box<EDetails>();

      final query  = (box.query(EDetails_.lnEnglish.notEquals('')
                                & EDetails_.buildingNameEnglish.equals(buildingName))..order(EDetails_.lnEnglish, flags:  Order.nullsLast )).build();
      final output = query.find();
      query.close();
      store.close();
      return output;

  }

  static Future<List<EDetails>> getPartWiseData(String partNo) async {
    final store = await openStore();
    var box = store.box<EDetails>();

    final query  = (box.query(EDetails_.lnEnglish.notEquals('')
    & EDetails_.partNo.equals(partNo))..order(EDetails_.lnEnglish, flags:  Order.nullsLast )).build();
    final output = query.find();
    query.close();
    store.close();
    return output;

  }

  static Future<List<EDetails>> getFamilyVoters(String searchType, String surName, String houseNo, String buildingAddress) async {
    final store = await openStore();
    var box = store.box<EDetails>();

    if(searchType.contains("Name")){
      final query  = (box.query(EDetails_.fnEnglish.notEquals('')
                                & EDetails_.lnEnglish.equals(surName)
                                & EDetails_.houseNoEnglish.equals(houseNo)
                                & EDetails_.buildingNameEnglish.equals(buildingAddress))..order(EDetails_.fnEnglish, flags:  Order.nullsLast )).build();
      final output = query.find();
      query.close();
      store.close();
      return output;
    }else{
      final query  = (box.query(EDetails_.lnEnglish.notEquals('')
                                & EDetails_.lnEnglish.equals(surName)
                                & EDetails_.houseNoEnglish.equals(houseNo)
                                & EDetails_.buildingNameEnglish.equals(buildingAddress))..order(EDetails_.lnEnglish, flags:  Order.nullsLast )).build();
      final output = query.find();
      query.close();
      store.close();
      return output;
    }
  }

  static Future<PartNoDropListModel> getPartNo() async {
    final store = await openStore();
    var box = store.box<EDetails>();

    Query<EDetails> query = box.query().build();
    Stream<EDetails> stream = query.stream();
    List<PartNo> listOptionItems = [];
    //adding part no to list
    await stream.forEach((EDetails user) => listOptionItems.add(PartNo(id: '${user.partNo}')));
    //set unique part no
    var seen = <String>{};
    listOptionItems = listOptionItems.where((element) => seen.add(element.id)).toList();
    listOptionItems.insert(0, PartNo( id: 'All'));
    query.close();
    store.close();
    return PartNoDropListModel(listOptionItems);
  }

  static Future<List<EDetails>> getPartWiseBuildings(String partNo) async {
    final store = await openStore();
    var box = store.box<EDetails>();
    List<EDetails> listBuilding = [];

    if(partNo == "All"){
      final query  = (box.query(EDetails_.buildingNameEnglish.notEquals(''))..order(EDetails_.buildingNameEnglish, flags:  Order.nullsLast )).build();
      Stream<EDetails> stream = query.stream();
      await stream.forEach((EDetails user) => listBuilding.add(EDetails(buildingNameEnglish: '${user.buildingNameEnglish}', buildingNameMarathi: '${user.buildingNameMarathi}')));
      var seen = <String>{};
      listBuilding = listBuilding.where((element) => seen.add(element.buildingNameEnglish!)).toList();
      query.close();
      store.close();
      return listBuilding;
    }else{
      final query  = (box.query(EDetails_.buildingNameEnglish.notEquals('')
                                & EDetails_.partNo.equals(partNo))..order(EDetails_.buildingNameEnglish, flags:  Order.nullsLast )).build();
      Stream<EDetails> stream = query.stream();
      await stream.forEach((EDetails user) => listBuilding.add(EDetails(buildingNameEnglish: '${user.buildingNameEnglish}', buildingNameMarathi: '${user.buildingNameMarathi}')));
      var seen = <String>{};
      listBuilding = listBuilding.where((element) => seen.add(element.buildingNameEnglish!)).toList();
      query.close();
      store.close();
      return listBuilding;
    }
  }

  static Future<List<AgeCountModel>> getAgeCountTable(String partNo, String ageRange) async {
    final store = await openStore();
    var box = store.box<EDetails>();
    int idx = ageRange.indexOf("-");
    var start = ageRange.substring(0,idx).trim();
    var end = ageRange.substring(idx+1,ageRange.length).trim();
    print("age 1" +start );
    print("age 2" +end );

    final query = box.query(
        EDetails_.partNo.equals(partNo)
            .and(EDetails_.age.greaterOrEqual(start)
            .and(EDetails_.age.lessOrEqual(end)
            )))
        .order(EDetails_.age)
        .build();

      List<AgeCountModel> listBuilding = [];

      List<EDetails> list = query.find();

      final int startCount = int.parse(start) ;
      final int endCount = int.parse(end);

      for(var i = startCount; i<= endCount ; i++){
        List<EDetails> maleList = list.where((eDetails) => eDetails.age!.contains(i.toString()) && eDetails.sex!.contains("M")).toList();
        List<EDetails> femaleList = list.where((eDetails) => eDetails.age!.contains(i.toString()) && eDetails.sex!.contains("F")).toList();
        listBuilding.add(AgeCountModel(partNo: partNo ,maleCount: maleList.length, femaleCount: femaleList.length, age: i));
      }

    query.close();


      store.close();
      return listBuilding;

  }

  static Future<List<EDetails>> getEasySearchData(String firstName, String lastName) async {
    final store = await openStore();
    var box = store.box<EDetails>();

    final query  = (box.query(EDetails_.lnEnglish.contains(lastName, caseSensitive: false) &
    EDetails_.fnEnglish.contains(firstName, caseSensitive: false) )..order(EDetails_.lnEnglish, flags:  Order.nullsLast | Order.caseSensitive )).build();
    final output = query.find();
    print(firstName);
    print(lastName);
    print(output.toString());
    query.close();
    store.close();
    return output;

  }

  static Future<EDetails> getPartSerialWiseData(String part, String serial) async {
    final store = await openStore();
    var box = store.box<EDetails>();

    final query  = (box.query(EDetails_.partNo.contains(part, caseSensitive: false) &
    EDetails_.serialNo.equals(serial, caseSensitive: false) )..order(EDetails_.lnEnglish, flags:  Order.nullsLast | Order.caseSensitive )).build();
    final output = query.find();
    query.close();
    store.close();
    return output.first;

  }


  static Future<List<SurnameCounterModel>> getSurnameCountData() async {
    final store = await openStore();
    var box = store.box<EDetails>();
    List<SurnameCounterModel> listSurname = [];

    final query  = (box.query(EDetails_.lnEnglish.notEquals(''))..order(EDetails_.lnEnglish, flags:  Order.nullsLast | Order.caseSensitive)).build();
    PropertyQuery<String> pq = query.property(EDetails_.lnEnglish);
    pq.distinct = true;
    pq.caseSensitive = false;
    List<String> surNames = pq.find();
    surNames.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    for (var element in surNames) {
      final query1  = (box.query(EDetails_.lnEnglish.contains(element, caseSensitive: false))..order(EDetails_.lnEnglish, flags:  Order.nullsLast | Order.caseSensitive)).build();
      final count = query1.count();
      listSurname.add(SurnameCounterModel(surName: element, count: count));
      query1.close();
    }
    query.close();
    store.close();
    return listSurname;

  }

  static Future<List<EDetails>> getSurnameCounterVoterList(String surName) async {
    final store = await openStore();
    var box = store.box<EDetails>();

    final query  = (box.query(EDetails_.lnEnglish.contains(surName, caseSensitive: false))..order(EDetails_.lnEnglish, flags:  Order.nullsLast )).build();
    final output = query.find();
    query.close();
    store.close();
    return output;
  }

  //User Details
  //=====================================================================================
  static Future<int> insertUserDetails(UserDetails user) async {
    final store = await openStore();
    var box = store.box<UserDetails>();
    var output = box.put(user);
    store.close();
    return output;
  }

  static Future<int> deleteUserDetails() async {
    final store = await openStore();
    var box = store.box<UserDetails>();
    var output =box.removeAll();
    store.close();
    return output;
  }

  static Future<List<UserDetails>> getUserDetails() async {
    final store = await openStore();
    var box = store.box<UserDetails>();
    var output = box.getAll();
    store.close();
    return output;
  }

  static Future<void> updateMacAddress(String macAddress) async {
    final store = await openStore();
    var box = store.box<UserDetails>();
    var output = box.get(1);
    output!.macAddress = macAddress;
    box.put(output);
    store.close();
  }

  static Future<void> updateUserDetails(UserDetails user) async {
    final store = await openStore();
    var box = store.box<UserDetails>();
    var output = box.get(1);
    output!.userName = user.userName;
    output.vidhansabhaName = user.vidhansabhaName;
    output.isUpdatable = user.isUpdatable;
    output.isMarkable = user.isMarkable;
    output.isVotingMakingReport = user.isVotingMakingReport;
    output.isContactReport = user.isContactReport;
    output.electionDate = user.electionDate;
    output.time = user.time;
    output.lineForOnlyPrintingPurpose = user.lineForOnlyPrintingPurpose;
    output.smsTimeLimit = user.smsTimeLimit;
    output.macAddress = user.macAddress;
    box.put(output);
    store.close();
  }

  static Future<void> updateColor(String partNo, String serialNo, String wardNo,String color) async {
    final store = await openStore();
    var box = store.box<EDetails>();
    final query  = (box.query(EDetails_.partNo.equals(partNo)
    & EDetails_.serialNo.equals(serialNo)
    & EDetails_.wardNo.equals(wardNo))..order(EDetails_.lnEnglish, flags:  Order.nullsLast )).build();
    final output = query.find();
    output.first.color = color;
    box.put(output.first);
    store.close();
  }

  static Future<void> updateShiftedDeath(String partNo, String serialNo, String wardNo,String type) async {
    final store = await openStore();
    var box = store.box<EDetails>();
    final query  = (box.query(EDetails_.partNo.equals(partNo)
    & EDetails_.serialNo.equals(serialNo)
    & EDetails_.wardNo.equals(wardNo))..order(EDetails_.lnEnglish, flags:  Order.nullsLast )).build();
    final output = query.find();
    output.first.shiftedDeath = type;
    box.put(output.first);
    store.close();
  }

  static Future<void> updateVotedNonVoted(String partNo, String serialNo, String wardNo,String type) async {
    final store = await openStore();
    var box = store.box<EDetails>();
    final query  = (box.query(EDetails_.partNo.equals(partNo)
    & EDetails_.serialNo.equals(serialNo)
    & EDetails_.wardNo.equals(wardNo))..order(EDetails_.lnEnglish, flags:  Order.nullsLast )).build();
    final output = query.find();
    output.first.votedNonVoted = type;
    box.put(output.first);
    store.close();
  }

  static Future<List<LanguageItem>> getLanguageList(String buildingName) async {
    final store = await openStore();
    var box = store.box<EDetails>();
    List<LanguageItem> languageList = [];

    final query  = (box.query(EDetails_.lnEnglish.notEquals('')
    & EDetails_.buildingNameEnglish.equals(buildingName))..order(EDetails_.lnEnglish, flags:  Order.nullsLast )).build();

    PropertyQuery<String> pq = query.property(EDetails_.lang);
    pq.distinct = true;
    pq.caseSensitive = false;
    List<String> languages = pq.find();
    languages.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    for (var element in languages) {
      final query1  = (box.query(EDetails_.lang.equals(element, caseSensitive: false)
      & EDetails_.lnEnglish.notEquals('')
      & EDetails_.buildingNameEnglish.equals(buildingName))..order(EDetails_.lnEnglish, flags:  Order.nullsLast | Order.caseSensitive)).build();
      final count = query1.count();
      languageList.add(LanguageItem(name: element, count: count));
      query1.close();
    }
    query.close();
    store.close();
    return languageList;
  }

  static Future<List<EDetails>> getLanguageWiseVoterList(String buildingName, String language) async {
    final store = await openStore();
    var box = store.box<EDetails>();

    final query  = (box.query(EDetails_.lnEnglish.notEquals('')
    & EDetails_.buildingNameEnglish.equals(buildingName, caseSensitive: false)
    & EDetails_.lang.equals(language, caseSensitive: false))..order(EDetails_.lnEnglish, flags:  Order.nullsLast )).build();
    final output = query.find();
    query.close();
    store.close();
    return output;
  }

  static Future<List<EDetails>> getAgeWiseVoterList(String partNo, String filter) async {
    final store = await openStore();
    var box = store.box<EDetails>();

    int idx = filter.indexOf("-");
    var gender = filter.substring(0,idx).trim();
    var age = filter.substring(idx+1,filter.length).trim();
    
    final query  = (box.query(EDetails_.lnEnglish.notEquals('')
    & EDetails_.partNo.equals(partNo)
    & EDetails_.age.equals(age)
    & EDetails_.sex.equals(gender, caseSensitive: false))..order(EDetails_.lnEnglish, flags:  Order.nullsLast )).build();
    final output = query.find();
    query.close();
    store.close();
    return output;
  }

  //============

  static Future<int> deleteAllBooths() async {
    final store = await openStore();
    var box = store.box<Vidhansabha>();
    var output = box.removeAll();
    store.close();
    return output;
  }

  static Future<List<int>> insertAllBooths(List<Vidhansabha> person) async {
    final store = await openStore();
    var box = store.box<Vidhansabha>();
    var output =box.putMany(person);
    store.close();
    return output;
  }

  static Future<Vidhansabha?> getBoothDetails(String wardNo, String partNo, String serialNo) async {
    final store = await openStore();
    var box = store.box<Vidhansabha>();

    final query  = (box.query(
        Vidhansabha_.wardNo.equals(wardNo)
        & Vidhansabha_.partNo.equals(partNo)
        .and(Vidhansabha_.from.greaterOrEqual(serialNo)
        .or(Vidhansabha_.to.lessOrEqual(serialNo))))).build();

    final list = query.find();
    for(Vidhansabha vidhan in list){
      print(vidhan.toString());
    }
    final output = query.findFirst();
    query.close();
    store.close();
    return output;
  }
}