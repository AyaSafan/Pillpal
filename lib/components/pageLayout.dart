import 'package:flutter/material.dart';
import 'package:pill_pal/colors.dart';
import 'package:pill_pal/components/curvedContainer.dart';

import 'package:pill_pal/components/FAB.dart';


class PageLayout extends StatelessWidget {
  PageLayout(
      {
        this.appBarTitle ='',
        this.child =  const SizedBox(height: 0, width: 0) ,
        this.containerChild = const SizedBox(height: 0, width: 0) ,
        this.appBarRight = const SizedBox(height: 0, width: 0),
        this.color = MyColors.Landing1
      });

  final Widget child;
  final Widget containerChild;
  final Widget appBarRight;
  final String appBarTitle;
  final Color color;


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
      body: Column(
        children: [
          child,
          CurvedContainer(
              containerChild
          ),
        ],
      ),
      floatingActionButton: FAB(),
    );
  }
}
