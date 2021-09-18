import 'package:floor/floor.dart';
import 'package:pill_pal/entities/medicine.dart';
import 'package:pill_pal/util/converters/ListStringConverter.dart';

@dao
abstract class MedicineDao {
  @Query('SELECT * FROM medicines')
  Stream<List<Medicine>> findAllMedicinesAsStream();

  @Query('SELECT * FROM medicines')
  Future<List<Medicine>> findAllMedicines();

  @Query('SELECT * FROM medicines WHERE name =:name')
  Future<List<Medicine>> findMedicineByName(String name);

  @Query('SELECT * FROM medicines WHERE id = :id')
  Future<Medicine?> findMedicineById(int id);

  @Query("UPDATE medicines SET supplyCurrent =:amount WHERE id = :id")
  Future<void> updateSupplyCurrent(int amount, int id);

  @Query("UPDATE medicines SET supplyCurrent = supplyCurrent-dose WHERE id = :id")
  Future<void> takeDose(int id);

  @TypeConverters([ListStringConverter])
  @Query("UPDATE medicines SET tags IN (:tags) WHERE id = :id")
  Future<void> updateTags(List<String> tags, int id);

  @insert
  Future<void> insertMedicine(Medicine medicine);

  @update
  Future<void> updateMedicine(Medicine medicine);

  @delete
  Future<void> deleteMedicine(Medicine medicine);

  @Query('DELETE FROM medicines')
  Future<void> deleteAllMedicine();

}