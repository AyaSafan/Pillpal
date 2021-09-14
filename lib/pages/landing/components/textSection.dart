import 'package:flutter/material.dart';

class TextSection extends StatelessWidget {
  //const TextSection({Key? key}) : super(key: key);

  final String title;
  final String paragraph;
  const TextSection(this.title, this.paragraph);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
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
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    fontFamily: 'Raleway',
                  ),
                ),
                SizedBox(height: 8,),
                Text(
                  paragraph,
                  softWrap: true,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                    fontFamily: 'Raleway',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
