import 'package:floor/floor.dart';
import 'package:majrekar_app/entities/MainData.dart';


@dao
abstract class MainDataDao {
  @Query('SELECT * FROM mainData WHERE id = :id')
  Future<MainData?> findDataById(int id);

  @Query('SELECT * FROM mainData')
  Stream<List<MainData>> findAllData();

  @insert
  Future<void> insertData(MainData note);

  @update
  Future<void> updateData(MainData note);

  @delete
  Future<void> deleteData(MainData note);

  @Query("DELETE FROM mainData")
  Future<void> deleteAllData();
}
