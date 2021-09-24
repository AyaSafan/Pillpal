import 'package:floor/floor.dart';
import 'package:flutter/cupertino.dart';


@Entity(
  tableName: 'medicines',
)
class Medicine {
  @PrimaryKey(autoGenerate: true)
  int? id;

  final String name;
  final String desc;
  final double supplyCurrent;
  final double supplyMin;
  final double dose;
  final double doseFrequency;
  final double capSize;
  final String pillShape;
  final Color pillColor;
  final List<String> tags;

  Medicine(
      {
        this.id,
        required this.name,
        this.desc: '',
        this.supplyCurrent: 0,
        this.supplyMin: 0,
        this.dose: 1,
        this.doseFrequency: 1,
        this.capSize: 0,
        this.pillShape: 'assets/medicine.png',
        this.pillColor: const Color(0xFFCCCCCC),
        this.tags: const [],
      });

    Medicine copyWith({
       int? id,
       String? name,
       String? desc,
       double? supplyCurrent,
       double? supplyMin,
       double? dose,
       double? capSize,
       String? pillShape,
       Color? pillColor,
       List<String>? tags,

    }){
      return Medicine(
          id: id ?? this.id,
          name: name ?? this.name,
          desc: desc ?? this.desc,
          supplyCurrent: supplyCurrent ?? this.supplyCurrent,
          supplyMin: supplyMin ?? this.supplyMin,
          dose: dose ?? this.dose,
          capSize: capSize ?? this.capSize,
          pillShape: pillShape ?? this.pillShape,
          pillColor: pillColor ?? this.pillColor,
          tags: tags ?? this.tags,

      );
    }

}