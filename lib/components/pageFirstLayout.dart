import 'package:flutter/material.dart';
import 'package:pill_pal/components/FAB.dart';
import 'package:pill_pal/components/curvedContainer.dart';
import 'package:pill_pal/theme.dart';


class PageFirstLayout extends StatelessWidget {
  PageFirstLayout(
      {
        this.appBarTitle ='',
        this.appBarRight = const SizedBox(height: 0, width: 0),
        this.color = MyColors.Landing2,
        this.topChild =  const SizedBox(height: 0, width: 0) ,
        this.containerChild = const SizedBox(height: 0, width: 0) ,
        //this.colorFAB = MyColors.MiddleBlueGreen,
        this.showFAB = true
      });

  final Widget topChild;
  final Widget containerChild;
  final Widget appBarRight;
  final String appBarTitle;
  final Color color;
  //final Color colorFAB;
  final bool showFAB;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color,
      appBar: AppBar(
        toolbarHeight: 80,
        titleSpacing: 30,
        title: Text(
          appBarTitle,
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'Raleway',
            color: Colors.black,
          ),
        ),
        actions: [
          appBarRight
        ],
        elevation: 0.0,
        backgroundColor: color,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
      ),
      body:
      Column(
        children: [
        topChild,
        CurvedContainer(
            containerChild
        ),
        ],
      ),
      floatingActionButton:
      Visibility(child: FAB(), visible: showFAB,),
    );
  }
}
