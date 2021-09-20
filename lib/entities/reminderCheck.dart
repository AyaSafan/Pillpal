import 'package:floor/floor.dart';
import 'package:pill_pal/entities/medicine.dart';

@Entity(
  tableName: 'reminders_check',
  foreignKeys: [
    ForeignKey(
        childColumns: ['reminder_id'],
        parentColumns: ['id'],
        entity: Medicine,
        onDelete: ForeignKeyAction.cascade
    )
  ],
)
class ReminderCheck {
  @PrimaryKey(autoGenerate: true)
  int? id;

  @ColumnInfo(name: 'reminder_id')
  final int? reminderId;
  //added for repeated reminders check
  final DateTime scheduledDateTime;
  final DateTime checkedDateTime;


  ReminderCheck(
      {
        this.id,
        this.reminderId,
        required this. scheduledDateTime,
        required this.checkedDateTime,
      });
}