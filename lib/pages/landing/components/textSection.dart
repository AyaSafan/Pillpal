import 'package:flutter/material.dart';

class TextSection extends StatelessWidget {

  final String title;
  final String paragraph;
  const TextSection(this.title, this.paragraph);

  @override
  Widget build(BuildContext context) {
    final defaultPadding = MediaQuery. of(context). size. width / 20;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: defaultPadding),
      child: Row(
        children: [
          Expanded(
            /*1*/
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                  ),
                ),
                SizedBox(height: 8,),
                Text(
                  paragraph,
                  softWrap: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
