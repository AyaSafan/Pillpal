import 'package:flutter/material.dart';

class CurvedContainer extends StatelessWidget {
  //const CurvedContainer({Key? key}) : super(key: key);
  final Widget child;
  const CurvedContainer(this.child);

  @override
  Widget build(BuildContext context) {
    final curveSize = MediaQuery. of(context). size. width / 20;
    return
      Flexible(
      fit: FlexFit.tight,
      child: Container(
        padding: EdgeInsets.all(curveSize),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(curveSize),
          ),
        ),
        child: child,
      ),
    );
  }
}
