import 'package:flutter/material.dart';
import 'package:pill_pal/colors.dart';
import 'package:pill_pal/components/skipButton.dart';
import 'package:pill_pal/components/nextButton.dart';
import 'package:pill_pal/components/textSection.dart';


class Landing1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    Widget image = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/landing1.png', height: 294, width: 300)
      ],
    );



    Widget body = Column(
        children:[
          SkipButton(),
          Expanded(
            child: ListView(
                children: [
                  image,
                  TextSection(
                      'Your PillPal is Here!',
                      'Pill Pal fulfills all your medication needs in one place. '
                  ),
                ]
            ),
          ),
          NextButton('/landing2'),
        ]);


    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if(details.primaryDelta! < 0) {
          Navigator.pushNamed(context, '/landing2');
        }
      },
      child: Scaffold(
            backgroundColor: MyColors.Landing1,
            body: Padding(
              padding: EdgeInsets.fromLTRB(10,50,10,25),
              child: body,
            )
        ),
    );
  }
}

