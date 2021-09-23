import 'package:flutter/material.dart';
import 'package:pill_pal/entities/medicine.dart';
import 'package:pill_pal/my_flutter_app_icons.dart';

class MedicineCard extends StatelessWidget {
  const MedicineCard({Key? key, required this.medicineItem }) : super(key: key);

  final Medicine medicineItem;

  Widget _buildIcon(double size, Color color, IconData iconData) {
    return Container(
      height: 30,
      width: 30,
      alignment: Alignment.center,
      child: Icon( iconData,
        color: color,
        size: size,),
    );
  }


  @override
  Widget build(BuildContext context) {
    final List<IconData> icons = [
      MyFlutterApp.capsule,
      MyFlutterApp.roundpill,
      Icons.medication,
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
              Stack(
                children: [
                  _buildIcon(30, Colors.black, icons[medicineItem.pillShapeNum]),
                  _buildIcon(26, medicineItem.pillColor, icons[medicineItem.pillShapeNum]),
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
