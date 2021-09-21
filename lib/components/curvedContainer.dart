import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CurvedContainer extends StatelessWidget {
  //const CurvedContainer({Key? key}) : super(key: key);
  final Widget child;
  const CurvedContainer(this.child);

  @override
  Widget build(BuildContext context) {
    final defaultPadding = MediaQuery. of(context). size. width / 20;
    return
      Expanded(
        child: Container(
          padding: EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(defaultPadding),
            ),
          ),
          child: child,
        ),
      );
  }
}
