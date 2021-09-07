import 'package:flutter/material.dart';

class CurvedContainer extends StatelessWidget {
  //const CurvedContainer({Key? key}) : super(key: key);
  final Widget child;
  const CurvedContainer(this.child);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: const Radius.circular(30),
          ),
        ),
        child: child,
      ),
    );
  }
}
