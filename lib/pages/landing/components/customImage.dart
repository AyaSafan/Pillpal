import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CustomImage extends StatelessWidget {
  const CustomImage({Key? key, required this.imagePath}) : super(key: key);
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    final defaultPadding = MediaQuery. of(context). size. width / 20;

    return Row(
      children: [
        Expanded(
          child:
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery. of(context). size. width*0.9,
              minWidth: MediaQuery. of(context). size. width*0.9,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Image.asset(imagePath, fit: BoxFit.fill),
            ),
          ),
        )
      ],
    );

  }
}
