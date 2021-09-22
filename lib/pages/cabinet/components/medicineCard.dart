import 'package:flutter/material.dart';
import 'package:pill_pal/entities/medicine.dart';
import 'package:pill_pal/my_flutter_app_icons.dart';

class MedicineCard extends StatelessWidget {
  const MedicineCard({Key? key, required this.medicineItem }) : super(key: key);

  final Medicine medicineItem;


  @override
  Widget build(BuildContext context) {
    final List<Icon> icons = [
      Icon( MyFlutterApp.capsule,
        color: medicineItem.pillColor,
        size: 30),
      Icon( MyFlutterApp.roundpill,
        color: medicineItem.pillColor,
        size: 30),
      Icon( Icons.medication,
        color: medicineItem.pillColor,
        size: 30)
    ];
    return
      GestureDetector(
        onTap: (){Navigator.pushNamed(context, '/medicine_item', arguments: medicineItem);},
        child: Card(
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                  height: 30,
                  width: 30,
                  child: icons[medicineItem.pillShapeNum]
              ),
              SizedBox(width: 16),
              Column(
                children: [
                  Text(
                      '${medicineItem.name}',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    runSpacing: 2,
                    spacing: 5,
                    children: medicineItem.tags.map((tag) =>
                        Chip(
                          label: Text('$tag',),
                          backgroundColor: Color(0xFFEEEEEE),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        )
                    ).toList(),
                  ),
                ],
              ),
            ],
          ),
        ),
    ),
      );
  }
}
