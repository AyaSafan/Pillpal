import 'package:flutter/material.dart';
import 'package:pill_pal/colors.dart';
import 'package:pill_pal/components/skipButton.dart';
import 'package:pill_pal/components/nextButton.dart';
import 'package:pill_pal/components/textSection.dart';


class Landing2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    Widget image = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/landing2.png', height: 280, width: 300)
      ],
    );



    Widget body = Column(
        children:[
          SkipButton(),
          Expanded(
            child: ListView(
                children: [
                  TextSection(
                      'PillPal Reminders',
                      'Pill reminder app for all medications. '
                      'Support for a wide range of dosing schemes within medication reminder. '
                  ),
                  image,
                ]
            ),
          ),
          NextButton('/landing3'),
        ]);


    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if(details.primaryDelta! > 0) {
          Navigator.pop(context);
        }
        else if(details.primaryDelta! < 0) {
          Navigator.pushNamed(context, '/landing3');
        }
      },
      child: Scaffold(
            backgroundColor: MyColors.Landing2,
            body: Padding(
              padding: EdgeInsets.fromLTRB(10,50,10,25),
              child: body,
            )
        ),
    );
  }
}

