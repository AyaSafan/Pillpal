import 'package:floor/floor.dart';
import 'package:pill_pal/entities/reminder.dart';

@dao
abstract class ReminderDao {

  @Query('SELECT * FROM reminders WHERE medicine_id = :medicineId')
  Future<List<Reminder>> findReminderByMedicineId(int medicineId);

  @Query('SELECT * FROM reminders WHERE repeated = 0 AND date =:date')
  Future<List<Reminder>> findReminderByDate(String date);

  @Query('SELECT * FROM reminders WHERE repeated = 1 AND day =:day')
  Future<List<Reminder>> findRepeatedReminderByDay(int day);

  @insert
  Future<void> insertReminder(Reminder reminder);

  @update
  Future<void> updateReminder(Reminder reminder);

  @delete
  Future<void> deleteReminder(Reminder reminder);

  @Query('DELETE FROM reminders')
  Future<void> deleteAllReminders();
}