import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({Key? key, this.icon = const SizedBox(), this.title='', this.data='', this.color=Colors.grey}) : super(key: key);

  final Widget icon;
  final String title;
  final String data;
  final Color color;


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return
      ConstrainedBox(
        constraints: BoxConstraints(
        minWidth: screenWidth*0.45,
        maxWidth: screenWidth*0.45,
      ),
        child: Card(
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    icon
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child:
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('$title', overflow: TextOverflow.ellipsis,),
                      Text('$data', overflow: TextOverflow.ellipsis, style: TextStyle(color: color, fontWeight: FontWeight.bold),)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
    ),
      );
  }
}
