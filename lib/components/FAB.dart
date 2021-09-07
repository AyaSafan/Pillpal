import 'package:flutter/material.dart';
import 'package:pill_pal/colors.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';

class FAB extends StatelessWidget {
  const FAB({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FabCircularMenu(
        fabOpenIcon: Icon(Icons.add),
        fabColor: MyColors.MiddleBlueGreen,
        ringColor: MyColors.Landing2,
        ringDiameter: 200,
        ringWidth: 50,
        children: <Widget>[
          IconButton(
              icon: Icon(Icons.medication),
              tooltip: 'Add Medicine',
              onPressed: () {}
          ),
          IconButton(
              icon: Icon(Icons.notification_add),
              tooltip: 'Add Reminder',
              onPressed: () {}
          )
        ]
    );
  }
}
