import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({Key? key, this.icon = const SizedBox(), this.title=''}) : super(key: key);

  final Widget icon;
  final String title;


  @override
  Widget build(BuildContext context) {
    final defaultPadding = MediaQuery. of(context). size. width / 20;

    return
      ConstrainedBox(
        constraints: BoxConstraints(
        minWidth: 140,
        maxWidth: 140,
        maxHeight: 140
      ),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(defaultPadding),
          ),
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
          child: Column(
            children: [
              Expanded(child:
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: icon,
                  ),
                ],
              )),
              Text('$title', overflow: TextOverflow.ellipsis,),

            ],
          ),
        ),
    ),
      );
  }
}
