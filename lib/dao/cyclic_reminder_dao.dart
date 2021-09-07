import 'package:floor/floor.dart';
import 'package:pill_pal/entities/cyclic_reminder.dart';

@dao
abstract class CyclicReminderDao {
  @Query('SELECT * FROM cyclic_reminder')
  Future<List<CyclicReminder>> findAllCyclicReminder();

  @Query('SELECT * FROM cyclic_reminder WHERE id = :id')
  Future<CyclicReminder?> findCyclicReminderById(int id);

  @insert
  Future<void> insertCyclicReminder(CyclicReminder reminder);

  @update
  Future<void> updateCyclicReminder(CyclicReminder reminder);

  @delete
  Future<void> deleteCyclicReminder(CyclicReminder reminder);

  @Query('DELETE FROM cyclic_reminder')
  Future<void> deleteAllCyclicReminders();
}