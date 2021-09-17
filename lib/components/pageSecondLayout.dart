import 'package:flutter/material.dart';
import 'package:pill_pal/components/FAB.dart';
import 'package:pill_pal/theme.dart';


class PageSecondLayout extends StatelessWidget {
  PageSecondLayout(
      {
        this.appBarTitle ='',
        this.appBarRight = const SizedBox(height: 0, width: 0),
        this.color = MyColors.Landing2,
        this.topChild =  const SizedBox(height: 0, width: 0) ,
        this.containerChild = const SizedBox(height: 0, width: 0) ,
        this.showFAB = true
      });

  final Widget topChild;
  final Widget containerChild;
  final Widget appBarRight;
  final String appBarTitle;
  final Color color;
  final bool showFAB;


  @override
  Widget build(BuildContext context) {
    final curveSize = MediaQuery. of(context). size. width / 20;
    return Scaffold(
      backgroundColor: Colors.white,
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
      ListView(
        children: [
          Container(
            color: color,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                topChild,
                Container(
                  height: curveSize,
                  padding: EdgeInsets.all(curveSize),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(curveSize),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(curveSize, 0, curveSize, 60),
            child: containerChild,
          ),

        ],
      ),
      floatingActionButton:
      Visibility(child: FAB(), visible: showFAB,),
    );
  }
}
