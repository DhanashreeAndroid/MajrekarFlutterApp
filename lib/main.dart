import 'package:floor/floor.dart';
import 'package:flutter/material.dart';
import 'package:majrekar_app/dao/maindata_dao.dart';
import 'package:majrekar_app/splash_screen.dart';

import 'database/main_data_database.dart';



void main() async {
  // This is required so ObjectBox can get the application directory
  // to store the database in.
  WidgetsFlutterBinding.ensureInitialized();
  final database =
  await $FloorMainDataDatabase.databaseBuilder('majrekar_data.db').build();
  final MainDataDao dao = database.mainDataDao;
  //objectbox = await ObjectBox.create();
  runApp(MyApp(dao: dao,database : database));
}

class MyApp extends StatelessWidget {
  final MainDataDao dao;
  final MainDataDatabase database;
  const MyApp({Key? key, required this.dao, required this.database}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(dao: dao, database: database,),
      debugShowCheckedModeBanner: false,
    );
  }
}


