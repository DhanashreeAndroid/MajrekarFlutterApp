import 'package:objectbox/objectbox.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:majrekar_app/model/DataModel.dart';
import 'package:majrekar_app/objectbox.g.dart';

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

}