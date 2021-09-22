import 'package:flutter/material.dart';


class PillShape extends StatelessWidget {
  final double? elevation;
  final Icon icon;
  final Color  pillColor;
  final void Function()? onTap;
  const PillShape(
      {this.elevation = 4, required this.icon ,
        this.pillColor = Colors.black, required this.onTap }
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
            child: icon
          ),
        ),
      ),
    );
  }

}

