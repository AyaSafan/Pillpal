import 'package:flutter/material.dart';
import 'package:pill_pal/dao/reminder_check_dao.dart';
import 'package:pill_pal/dao/reminder_dao.dart';
import 'package:pill_pal/pages/dayRemindersPage/components/dateCard.dart';


class DayRemindersPage extends StatefulWidget {
  const DayRemindersPage({Key? key,
    required this.reminderDao,
    required this.reminderCheckDao,
    required this.dateTime
  }) : super(key: key);

  final ReminderDao reminderDao;
  final ReminderCheckDao reminderCheckDao;
  final DateTime dateTime;

  @override
  _DayRemindersPageState createState() => _DayRemindersPageState();
}

class _DayRemindersPageState extends State<DayRemindersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(MediaQuery. of(context). size. width / 20),
        child: Column(
          children: [
            Row(
              children: [
                DateCard(widget.dateTime),
              ],
            ),
            Expanded(
              child: Container(
                child: ListView(
                  children: [

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
