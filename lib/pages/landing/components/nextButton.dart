import 'package:flutter/material.dart';

class NextButton extends StatelessWidget {

  final String nextRoute;
  const NextButton(this.nextRoute);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          style: TextButton.styleFrom(
            primary: Colors.black,
            textStyle: const TextStyle(fontSize: 15, letterSpacing: 2),
          ),
          onPressed: () {
            if (nextRoute == '/home') {
              Navigator.pushNamedAndRemoveUntil(context, nextRoute, (route) => false);
            }else {
              Navigator.pushNamed(context, nextRoute);
            }
          },
          child: Text("${nextRoute == '/home'? 'START': 'NEXT'}"),
        ),
      ],
    );
  }
}
