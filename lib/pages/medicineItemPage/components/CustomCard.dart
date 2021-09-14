import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pill_pal/colors.dart';
class CustomCard extends StatelessWidget {
  const CustomCard({Key? key, this.icon = const SizedBox(), this.title='', this.data='', this.color=Colors.grey}) : super(key: key);

  final Widget icon;
  final String title;
  final String data;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
        elevation: 8,
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
      );
  }
}
