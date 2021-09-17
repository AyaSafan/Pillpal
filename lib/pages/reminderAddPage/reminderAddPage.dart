import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pill_pal/components/pageFirstLayout.dart';
import 'package:pill_pal/theme.dart';

class ReminderAddPage extends StatefulWidget {
  const ReminderAddPage({Key? key}) : super(key: key);

  @override
  _ReminderAddPageState createState() => _ReminderAddPageState();
}

class _ReminderAddPageState extends State<ReminderAddPage> {

  TimeOfDay _time = TimeOfDay(hour: 7, minute: 15);

  void _selectTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (newTime != null) {
      setState(() {
        _time = newTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {


    return PageFirstLayout(
      appBarTitle: 'Add Reminder',
      color: MyColors.Landing1,
      showFAB: false,
      containerChild: ListView(
        children: [
          GestureDetector(
            onTap: _selectTime,
            child: TextFormField(
              enabled: false,
              decoration: InputDecoration(
                labelText: '${_time.format(context)}',
                labelStyle: TextStyle(
                    color: Colors.black54
                ),
                suffixIcon: Icon(Icons.alarm),
                disabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide( color: Colors.grey,),
                ),

              ),
            ),
          ),
          SizedBox(height: 24,),


        ],
      ),


    );
  }
}
