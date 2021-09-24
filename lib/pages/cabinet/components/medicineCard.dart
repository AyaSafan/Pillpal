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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Stack(
                children: [
                  Container(height: 30, width: 30, color:medicineItem.pillColor,),
                  Image.asset(medicineItem.pillShape, height: 30, width: 30,)
                ],
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      '${medicineItem.name}',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    runSpacing: 2,
                    spacing: 5,
                    children: medicineItem.tags.map((tag) =>
                        Chip(
                          label: Text('$tag', style: Theme.of(context).textTheme.caption!,),
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
