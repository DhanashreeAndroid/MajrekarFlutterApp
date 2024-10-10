import 'package:majrekar_app/database/main_data_database.dart';

class DatabaseHelper{
  static const _databaseName = "majrekar_data.db";

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  late $FloorMainDataDatabase _database;

  Future<$FloorMainDataDatabase> get database async{
    if(_database !=null){
      return _database;
    }
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async{
    return await $FloorMainDataDatabase
        .databaseBuilder(_databaseName)
        .build();
  }
}