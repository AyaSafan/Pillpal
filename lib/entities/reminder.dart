import 'package:floor/floor.dart';
import 'package:pill_pal/entities/medicine.dart';

@Entity(
  tableName: 'reminder',
  foreignKeys: [
    ForeignKey(
      childColumns: ['medicine_id'],
      parentColumns: ['id'],
      entity: Medicine,
    )
  ],
)
class Reminder {
  @PrimaryKey(autoGenerate: true)
  int? id;

  @ColumnInfo(name: 'medicine_id')
  final int medicineId;

  final DateTime dateTime;  
  final String label;
  final bool checked;


  Reminder(
      {
        this.id,
        required this.medicineId,
        required this.dateTime,
        this.label: '',
        this.checked: false,

      });
}