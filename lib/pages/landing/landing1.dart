import 'package:flutter/material.dart';
import 'package:pill_pal/pages/landing/components/customImage.dart';
import 'package:pill_pal/pages/landing/components/nextButton.dart';
import 'package:pill_pal/pages/landing/components/skipButton.dart';
import 'package:pill_pal/pages/landing/components/textSection.dart';
import 'package:pill_pal/theme.dart';


class Landing1 extends StatelessWidget {

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
                    CustomImage(imagePath: 'assets/landing1.png'),
                    TextSection(
                        'Your PillPal is Here!',
                        'Pill Pal fulfills all your medication needs in one place. '
                    ),
                  ]
              ),
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

