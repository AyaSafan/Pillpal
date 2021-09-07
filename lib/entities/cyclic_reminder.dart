import 'package:floor/floor.dart';
import 'package:pill_pal/entities/medicine.dart';

@Entity(
  tableName: 'cyclic_reminder',
  foreignKeys: [
    ForeignKey(
      childColumns: ['medicine_id'],
      parentColumns: ['id'],
      entity: Medicine,
    )
  ],
)
class CyclicReminder {
  @PrimaryKey(autoGenerate: true)
  int? id;

  @ColumnInfo(name: 'medicine_id')
  final int medicineId;

  final List<String> dates;
  final DateTime dateTime;
  final String label;
  final bool checked;


  CyclicReminder(
      {
        this.id,
        required this.medicineId,
        required this.dates,
        required this.dateTime,
        this.label: '',
        this.checked: false,

      });
}