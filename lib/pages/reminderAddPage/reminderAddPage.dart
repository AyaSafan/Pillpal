import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pill_pal/colors.dart';
import 'package:pill_pal/components/FAB.dart';

import 'package:pill_pal/components/pageFirstLayout.dart';
import 'package:pill_pal/components/pageSecondLayout.dart';

import 'package:pill_pal/pages/calender/components/dateCard.dart';

import 'package:pill_pal/database.dart';
import 'package:pill_pal/entities/reminder.dart';
import 'package:pill_pal/pages/calender/components/detailsButton.dart';

import 'package:table_calendar/table_calendar.dart';
//import 'package:percent_indicator/percent_indicator.dart';

class ReminderAddPage extends StatefulWidget {
  const ReminderAddPage({Key? key}) : super(key: key);

  @override
  _CalenderState createState() => _CalenderState();
}

class _CalenderState extends State<ReminderAddPage> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  List<Reminder> _selectedEvents = [];
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  var cyclicEvents = new Map();


  Future<List<Reminder>> getDayReminders(DateTime date) async {
    final database = await $FloorAppDatabase.databaseBuilder('app_database.db')
        .build();
    final reminderDao = database.reminderDao;
    final reminders = await reminderDao.findReminderByDate(
        DateTime(date.year, date.month, date.day).toString());
    // final repeatedReminders =await reminderDao.findRepeatedReminderByDay(date.weekday);
    reminders.addAll(cyclicEvents[date.weekday] ?? []);
    return reminders;
  }

  Future<void> getRepeatedReminders() async {
    final database = await $FloorAppDatabase.databaseBuilder('app_database.db')
        .build();
    final reminderDao = database.reminderDao;
    for (var i = 1; i <= 7; i++) {
      final dayRepeatedReminders = await reminderDao.findRepeatedReminderByDay(
          i);
      cyclicEvents[i] = dayRepeatedReminders;
    }
    return;
  }


  @override
  void initState() {
    super.initState();
    setState(() {
      _selectedDay = _focusedDay;
    });
    getDayReminders(_selectedDay!).then((value) {
      setState(() {
        _selectedEvents = value;
      });
    });

    getRepeatedReminders().then((value) => null);
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _focusedDay = focusedDay;
        _selectedDay = selectedDay;
      });
      getDayReminders(_selectedDay!).then((value) {
        setState(() {
          _selectedEvents = value;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

    );
  }
}
