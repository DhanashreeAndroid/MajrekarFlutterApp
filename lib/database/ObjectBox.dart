import 'package:flutter/foundation.dart';
import 'package:objectbox/objectbox.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:majrekar_app/model/DataModel.dart';
import 'package:majrekar_app/objectbox.g.dart';

import '../menu_pages/buildingWiseSearch/partno_drop_list_model.dart';

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

  static Future<List<EDetails>> getAllBuildingWiseData(String houseNo, String buildingName) async {
    final store = await openStore();
    var box = store.box<EDetails>();

      final query  = (box.query(EDetails_.lnEnglish.notEquals('')
                                & EDetails_.houseNoEnglish.equals(houseNo)
                                & EDetails_.buildingNameEnglish.equals(buildingName))..order(EDetails_.lnEnglish, flags:  Order.nullsLast )).build();
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

    if(partNo == "All"){
      final query  = (box.query(EDetails_.buildingNameEnglish.notEquals(''))..order(EDetails_.buildingNameEnglish, flags:  Order.nullsLast )).build();
      final output = query.find();
      query.close();
      store.close();
      return output;
    }else{
      final query  = (box.query(EDetails_.buildingNameEnglish.notEquals('')
                                & EDetails_.partNo.equals(partNo))..order(EDetails_.buildingNameEnglish, flags:  Order.nullsLast )).build();
      final output = query.find();
      query.close();
      store.close();
      return output;
    }


  }
}