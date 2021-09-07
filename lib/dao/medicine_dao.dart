import 'package:floor/floor.dart';
import 'package:pill_pal/entities/medicine.dart';
import 'package:pill_pal/services/ListConverter.dart';

@dao
abstract class MedicineDao {
  @Query('SELECT * FROM medicine')
  Future<List<Medicine>> findAllMedicines();

  @Query('SELECT * FROM medicine WHERE name =:name')
  Future<List<Medicine>> findMedicineByName(String name);

  @Query('SELECT * FROM medicine WHERE id = :id')
  Future<Medicine?> findMedicineById(int id);

  @Query("UPDATE medicine SET amountAvailable =:amount WHERE id = :id")
  Future<void> updateAmountAvailable(int amount, int id);

  @Query("UPDATE medicine SET amountAvailable = amountAvailable-dose WHERE id = :id")
  Future<void> takeDose(int id);

  @TypeConverters([ListConverter])
  @Query("UPDATE medicine SET tags IN (:tags) WHERE id = :id")
  Future<void> updateTags(List<String> tags, int id);

  @insert
  Future<void> insertMedicine(Medicine medicine);

  @update
  Future<void> updateMedicine(Medicine medicine);

  @delete
  Future<void> deleteMedicine(Medicine medicine);

  @Query('DELETE FROM medicine')
  Future<void> deleteAllMedicine();

}