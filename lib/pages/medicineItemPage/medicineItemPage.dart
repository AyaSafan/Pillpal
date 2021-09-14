import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pill_pal/colors.dart';

import 'package:pill_pal/components/pageFirstLayout.dart';
import 'package:pill_pal/components/pageSecondLayout.dart';
import 'package:pill_pal/entities/medicine.dart';
import 'package:pill_pal/pages/medicineItemPage/components/CustomCard.dart';

class MedicineItemPage extends StatelessWidget {
  const MedicineItemPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final med = ModalRoute.of(context)!.settings.arguments as Medicine;
    return PageSecondLayout(
      appBarTitle: med.name ,
      appBarRight: IconButton(
        icon: Icon(Icons.more_vert),
        onPressed: (){
          print('hi');
          Navigator.pushNamed(context, '/medicine_edit', arguments: med);
        },
      ),
      showFAB: false,
      topChild:  Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                med.desc.isNotEmpty ? Column(
                  children: [
                    Text(
                      med.desc,
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Raleway',
                      ),
                    ),
                    SizedBox(height: 16,),
                  ],
                ) : SizedBox(),
                Wrap(
                  runSpacing: 2,
                  spacing: 5,
                  children: med.tags.map((tag) =>
                      Chip(
                        label: Text('$tag', ),
                        backgroundColor: MyColors.TealBlue.withOpacity(0.5),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      )
                  ).toList(),
                ),
                SizedBox(height: 16,),

              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [Image.asset('assets/pill.png', height: 60, width: 80)],
          ),
        ],
      ),
      containerChild: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              CustomCard(
                title: 'Current Supply',
                data: '${med.supplyCurrent} pills',
                icon: Icon(
                  Icons.assignment_turned_in,
                  color: MyColors.TealBlue,
                ),
                color: MyColors.TealBlue,
              ),
              CustomCard(
                title: 'Minimun Supply',
                data: '${med.supplyMin} pills',
                icon: Icon(
                  Icons.assignment_late,
                  color: Color(0xffda4625),
                ),
                color: Color(0xffda4625),
              ),
            ],
          ),
          Row(
            children: [
              CustomCard(
                title: 'Dose',
                data: '${med.dose} pills/dose',
                icon: Icon(
                  Icons.timelapse,
                  color: Colors.purple,
                ),
                color: Colors.purple,
              ),
              CustomCard(
                title: 'Daily Amount',
                data: '${med.doseFrequency} dose/day',
                icon: Icon(
                  Icons.access_time_filled,
                  color: MyColors.MiddleBlueGreen,
                ),
                color: MyColors.MiddleBlueGreen,
              ),
            ],
          ),
          Row(children: [
            CustomCard(
              title: 'Cap Size',
              data: '${med.capSize} mg',
              icon: Icon(
                Icons.hourglass_bottom,
                color: MyColors.MiddleRed,
              ),
              color: MyColors.MiddleRed,
            ),
            CustomCard(
              title: 'Shape',
              data: '${med.pillShape}',
              icon: Icon(
                Icons.hourglass_bottom,
                color: MyColors.Aero,
              ),
              color: MyColors.Aero,
            ),
          ],)
        ],
      )
    );
  }
}
