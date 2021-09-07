import 'package:flutter/material.dart';
import 'package:pill_pal/colors.dart';
import 'package:pill_pal/components/nextButton.dart';
import 'package:pill_pal/components/textSection.dart';


class Landing3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    Widget image = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/landing3.png', height: 307, width: 300)
      ],
    );


    Widget body = Column(
        children:[
          //skipButton,
          Expanded(
            child: ListView(
                children: [
                  image,
                  TextSection('PillPal Tracker',
                      'Pill tracker with a logbook for skipped and confirmed intakes. '
                      'Track your tablets, dose, measurements in a comprehensive health journal. '
                  ),
                ]
            ),
          ),
          NextButton('/home'),
        ]);


    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if(details.primaryDelta! > 0) {
          Navigator.pop(context);
        }
        else if(details.primaryDelta! < 0) {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        }
      },
      child: Scaffold(
            backgroundColor: MyColors.Landing3,
            body: Padding(
              padding: EdgeInsets.fromLTRB(10,50,10,25),
              child: body,
            )
        ),
    );
  }
}

