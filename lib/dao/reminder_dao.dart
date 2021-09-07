import 'package:floor/floor.dart';
import 'package:pill_pal/entities/reminder.dart';

@dao
abstract class ReminderDao {
  @Query('SELECT * FROM reminder')
  Future<List<Reminder>> findAllReminders();

  @Query('SELECT * FROM reminder WHERE id = :id')
  Future<Reminder?> findReminderById(int id);

  @Query('SELECT * FROM reminder WHERE dateTime = :dateTime')
  Future<List<Reminder>> findReminderByDate(DateTime dateTime);

  @insert
  Future<void> insertReminder(Reminder reminder);

  @update
  Future<void> updateReminder(Reminder reminder);

  @delete
  Future<void> deleteReminder(Reminder reminder);

  @Query('DELETE FROM reminder')
  Future<void> deleteAllReminders();
}