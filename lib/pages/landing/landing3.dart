import 'package:flutter/material.dart';
import 'package:pill_pal/pages/landing/components/customImage.dart';
import 'package:pill_pal/pages/landing/components/nextButton.dart';
import 'package:pill_pal/pages/landing/components/textSection.dart';
import 'package:pill_pal/theme.dart';

class Landing3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    Widget body = Column(
        children:[
          //skipButton,
          Expanded(
            child:
            Center(
              child: ListView(
                  shrinkWrap: true,
                  children: [
                    CustomImage(imagePath: 'assets/landing3.png'),
                    TextSection('PillPal Cabinet',
                        'Track your supply, dose, measurements in a comprehensive health journal. '
                    ),
                  ]
              ),
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

