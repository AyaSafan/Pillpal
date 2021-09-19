import 'package:flutter/material.dart';

class DetailsButton extends StatelessWidget {

  final DateTime dateTime;
  const DetailsButton(this.dateTime);


  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        primary: Colors.black,
        padding: EdgeInsets.only(bottom: 0),
        alignment: Alignment.bottomLeft,
        textStyle: const TextStyle(
            fontSize: 15, letterSpacing: 1, fontFamily: 'Raleway'),
      ),
      onPressed: () {
        Navigator.pushNamed(context, '/reminder_item', arguments: dateTime);
      },
      child: Row(
        children: [
          Text("More details "),
          Icon(
            Icons.double_arrow_outlined,
            size: 15,
          ),
        ],
      ),
    );
  }
}
