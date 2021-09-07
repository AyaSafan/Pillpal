import 'package:floor/floor.dart';
import 'package:flutter/cupertino.dart';


@Entity(
  tableName: 'medicine',
)
class Medicine {
  @PrimaryKey(autoGenerate: true)
  int? id;

  final String name;
  final String desc;
  final int amountAvailable;
  final int supplyMin;
  final int dose;
  final int capSize;
  final String pillShape;
  final Color pillColor;
  final List<String> tags;

  Medicine(
      {
        this.id,
        required this.name,
        this.desc: '',
        this.amountAvailable: 0,
        this.supplyMin: 0,
        this.dose: 1,
        this.capSize: 0,
        this.pillShape: 'other',
        this.pillColor: const Color(0xFFCCCCCC),
        this.tags: const [],
      });
}