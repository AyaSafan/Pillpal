import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:pill_pal/theme.dart';

class FAB extends StatelessWidget {
  const FAB({Key? key}) : super(key: key);
  // const FAB({Key? key,
  //   this.color = MyColors.Landing2,
  //   this.colorFAB = MyColors.MiddleBlueGreen,
  // }) : super(key: key);
  //
  // final Color color;
  // final Color colorFAB;

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
              onPressed: () {Navigator.pushNamed(context, '/medicine_add');}
          ),
          IconButton(
              icon: Icon(Icons.notification_add),
              tooltip: 'Add Reminder',
              onPressed: () {Navigator.pushNamed(context, '/reminder_add');}
          )
        ]
    );
  }
}
