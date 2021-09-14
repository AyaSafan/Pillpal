import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';


class ReminderAddPage extends StatefulWidget {
  const ReminderAddPage({Key? key}) : super(key: key);

  @override
  _ReminderAddPageState createState() => _ReminderAddPageState();
}

class _ReminderAddPageState extends State<ReminderAddPage> {
  Color currentColor = Colors.limeAccent;

  void changeColor(Color color) => setState(() => currentColor = color);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:   RaisedButton(
        elevation: 3.0,
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Select a color'),
                content: SingleChildScrollView(
                  child: BlockPicker(
                    pickerColor: currentColor,
                    onColorChanged: changeColor,
                  ),
                ),
              );
            },
          );
        },
        child: const Text('Change me'),
        color: currentColor,
        textColor: useWhiteForeground(currentColor)
            ? const Color(0xffffffff)
            : const Color(0xff000000),
      )
    );
  }
}
