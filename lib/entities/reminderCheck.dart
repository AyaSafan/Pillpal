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
  final int reminderID;
  final DateTime scheduledDateTime;
  final DateTime checkedDateTime;


  ReminderCheck(
      {
        this.id,
        required this.reminderID,
        required this. scheduledDateTime,
        int? checkedDateTime,
      }) : this.checkedDateTime = DateTime.fromMillisecondsSinceEpoch(checkedDateTime?? DateTime.now().millisecondsSinceEpoch );
}