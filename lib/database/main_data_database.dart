import 'dart:async';

import 'package:floor/floor.dart';
import 'package:majrekar_app/dao/maindata_dao.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../entities/MainData.dart';
part 'main_data_database.g.dart';

@Database(version: 1, entities: [MainData])
abstract class MainDataDatabase extends FloorDatabase {
  MainDataDao get mainDataDao;
}
