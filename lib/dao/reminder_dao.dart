import 'package:floor/floor.dart';
import 'package:pill_pal/entities/reminder.dart';

@dao
abstract class ReminderDao {
  @Query('SELECT * FROM reminders')
  Stream<List<Reminder>> findAllRemindersAsStream();

  @Query('SELECT * FROM reminders WHERE medicine_id = :medicineId')
  Future<List<Reminder>> findReminderByMedicineId(int medicineId);

  @Query('SELECT * FROM reminders WHERE repeated = 0 AND date =:date OR repeated = 1 AND day =:day OR day=0')
  Future<List<Reminder>> findReminderForDay(String date, int day);

  @Query('SELECT * FROM reminders WHERE repeated = 0 AND date =:date OR repeated = 1 AND day =:day OR day=0')
  Stream<List<Reminder>> findReminderForDayAsStream(String date, int day);

  @insert
  Future<void> insertReminder(Reminder reminder);

  @update
  Future<void> updateReminder(Reminder reminder);

  @delete
  Future<void> deleteReminder(Reminder reminder);

  @Query('DELETE FROM reminders')
  Future<void> deleteAllReminders();
}