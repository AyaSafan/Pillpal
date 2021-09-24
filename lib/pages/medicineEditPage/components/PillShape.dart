import 'package:flutter/material.dart';


class PillShape extends StatelessWidget {
  final double? elevation;
  final Color  pillColor;
  final String pillImage;
  final void Function()? onTap;
  const PillShape(
      {this.elevation = 4,
        this.pillColor = Colors.black, required this.onTap , this.pillImage = 'assets/medicine.png'}
        );


  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: onTap  ,
      child: Card(
        elevation: elevation,
        child: Container(
          height: 80,
          width: 80,
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Center(
            child: Stack(
              children: [
                 Container(height: 60, width: 60, color: pillColor,),
                 Image.asset(pillImage, height: 60, width: 60,),
              ],
            ),
          ),
        ),
      ),
    );
  }

}

