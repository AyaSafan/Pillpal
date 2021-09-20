import 'package:floor/floor.dart';
import 'package:pill_pal/entities/reminderCheck.dart';
import 'package:pill_pal/util/converters/DateTimeConverter.dart';

@dao
abstract class ReminderCheckDao {
  // @Query('SELECT * FROM reminders_check')
  // Future<List<ReminderCheck>> findAllReminderChecks();
  //
  // @Query('SELECT * FROM reminders_check WHERE id = :id')
  // Future<ReminderCheck?> findReminderCheckById(int id);
  //
  // @TypeConverters([DateTimeConverter])
  // @Query('SELECT * FROM reminders_check WHERE scheduledDateTime =:datetime')
  // Future<List<ReminderCheck>> findReminderByScheduledDate(DateTime datetime);

  @TypeConverters([DateTimeConverter])
  @Query('SELECT * FROM reminders_check WHERE scheduledDateTime =:datetime AND reminder_id =:reminderId')
  Future<ReminderCheck?> findReminderByScheduledDate(DateTime datetime, int reminderId);

  @insert
  Future<void> insertReminderCheck(ReminderCheck check);

  @update
  Future<void> updateReminderCheck(ReminderCheck check);

  @delete
  Future<void> deleteReminderCheck(ReminderCheck check);

  @Query('DELETE FROM reminders_check')
  Future<void> deleteAllReminderChecks();
}