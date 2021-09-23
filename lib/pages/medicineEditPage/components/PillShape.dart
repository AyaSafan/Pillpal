import 'package:flutter/material.dart';


class PillShape extends StatelessWidget {
  final double? elevation;
  final IconData iconData;
  final Color  pillColor;
  final void Function()? onTap;
  const PillShape(
      {this.elevation = 4, required this.iconData ,
        this.pillColor = Colors.black, required this.onTap }
        );

  Widget _buildIcon(double size, Color color) {
    return Container(
      height: 60,
      width: 60,
      alignment: Alignment.center,
      child: Icon( iconData,
        color: color,
        size: size,),
    );
  }


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
                _buildIcon(60, Colors.black),
                _buildIcon(56, pillColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

}

