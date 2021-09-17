import 'package:flutter/material.dart';

class DetailsButton extends StatelessWidget {
  const DetailsButton({Key? key}) : super(key: key);

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
      onPressed: () {},
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
