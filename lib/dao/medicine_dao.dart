import 'package:floor/floor.dart';
import 'package:pill_pal/entities/medicine.dart';

@dao
abstract class MedicineDao {
  @Query('SELECT * FROM medicines')
  Stream<List<Medicine>> findAllMedicinesAsStream();

  @Query('SELECT * FROM medicines')
  Future<List<Medicine>> findAllMedicines();

  @Query('SELECT * FROM medicines WHERE id = :id')
  Future<Medicine?> findMedicineById(int id);

  @insert
  Future<void> insertMedicine(Medicine medicine);

  @update
  Future<void> updateMedicine(Medicine medicine);

  @delete
  Future<void> deleteMedicine(Medicine medicine);

  @Query('DELETE FROM medicines')
  Future<void> deleteAllMedicine();

}