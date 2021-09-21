import 'package:flutter/material.dart';
import 'package:pill_pal/entities/medicine.dart';

class MedicineCard extends StatelessWidget {
  const MedicineCard({Key? key, required this.medicineItem }) : super(key: key);

  final Medicine medicineItem;

  @override
  Widget build(BuildContext context) {
    return
      GestureDetector(
        onTap: (){Navigator.pushNamed(context, '/medicine_item', arguments: medicineItem);},
        child: Card(
        elevation: 8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Padding(
               padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
               child: Row(
                 children: [
                   Icon(
                     Icons.medication,
                     color: medicineItem.pillColor,
                   ),
                   SizedBox(width: 10),
                   Text(
                       '${medicineItem.name}',
                     style: TextStyle(
                       color: Colors.black,
                     ),
                   ),
                 ],
               ),
             ),
            Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 15),
                child:
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
            ),

          ],
        ),
    ),
      );
  }
}
