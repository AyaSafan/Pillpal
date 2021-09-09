import 'package:floor/floor.dart';
import 'package:pill_pal/entities/medicine.dart';
import 'package:pill_pal/services/DateTimeConverter.dart';


@Entity(
  tableName: 'reminders',
  foreignKeys: [
    ForeignKey(
      childColumns: ['medicine_id'],
      parentColumns: ['id'],
      entity: Medicine,
      onDelete: ForeignKeyAction.cascade
    )
  ],
)
class Reminder {
  @PrimaryKey(autoGenerate: true)
  int? id;

  @ColumnInfo(name: 'medicine_id')
  final int medicineId;
  final String date;
  final int day;
  final DateTime dateTime;  
  final String label;
  final bool repeated;
  //final bool checked;

  @TypeConverters([DateTimeConverter])
  Reminder(
      {
        this.id,
        required this.medicineId,
        // required this.date,
        // required this.day,
        // required this.dateTime,
        String? date,
        int? day,
        int? dateTime,
        this.label: '',
        this.repeated: false
        //this.checked: false,

      }) : this.dateTime = DateTime.fromMillisecondsSinceEpoch(dateTime?? DateTime.now().millisecondsSinceEpoch ) ,
           this.date = date ?? DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).toString(),
           this.day = day ?? DateTime.now().day ;
}