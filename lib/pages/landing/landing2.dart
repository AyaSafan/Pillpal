import 'package:flutter/material.dart';
import 'package:pill_pal/pages/landing/components/customImage.dart';
import 'package:pill_pal/pages/landing/components/nextButton.dart';
import 'package:pill_pal/pages/landing/components/skipButton.dart';
import 'package:pill_pal/pages/landing/components/textSection.dart';
import 'package:pill_pal/theme.dart';


class Landing2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    Widget body = Column(
        children:[
          SkipButton(),
          Expanded(
            child:
            Center(
              child: ListView(
                  shrinkWrap: true,
                  children: [
                    TextSection(
                        'PillPal Reminders',
                        'Pill reminder app for all medications. '
                        'Support for a wide range of dosing schemes within medication reminder. '
                    ),
                    CustomImage(imagePath: 'assets/landing2.png'),
                  ]
              ),
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

