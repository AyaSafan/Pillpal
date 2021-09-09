import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pill_pal/colors.dart';

import 'package:pill_pal/components/pageLayout.dart';

import 'package:pill_pal/components/dateCard.dart';

import 'package:pill_pal/database.dart';
import 'package:pill_pal/entities/reminder.dart';

import 'package:table_calendar/table_calendar.dart';
//import 'package:percent_indicator/percent_indicator.dart';

class Calender extends StatefulWidget {
  const Calender({Key? key}) : super(key: key);

  @override
  _CalenderState createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;
  List<Reminder> _selectedEvents = [];
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  var cyclicEvents = new Map();



  Future<List<Reminder>> getDayReminders(DateTime date) async {
    final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    final reminderDao = database.reminderDao;
    final reminders = await reminderDao.findReminderByDate(DateTime(date.year, date.month, date.day).toString());
    // final repeatedReminders =await reminderDao.findRepeatedReminderByDay(date.weekday);
    reminders.addAll(cyclicEvents[date.weekday]??[]);
    return reminders;
  }

  Future<void> getRepeatedReminders() async {
    final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    final reminderDao = database.reminderDao;
    final mondayRepeatedReminders =await reminderDao.findRepeatedReminderByDay(DateTime.monday);
    cyclicEvents[1]= mondayRepeatedReminders;
    final tuesdayRepeatedReminders =await reminderDao.findRepeatedReminderByDay(DateTime.tuesday);
    cyclicEvents[2]= tuesdayRepeatedReminders;
    final wednesdayRepeatedReminders =await reminderDao.findRepeatedReminderByDay(DateTime.wednesday);
    cyclicEvents[3]= wednesdayRepeatedReminders;
    final thursdayRepeatedReminders =await reminderDao.findRepeatedReminderByDay(DateTime.thursday);
    cyclicEvents[4]= thursdayRepeatedReminders;
    final fridayRepeatedReminders =await reminderDao.findRepeatedReminderByDay(DateTime.friday);
    cyclicEvents[5]= fridayRepeatedReminders;
    final saturdayRepeatedReminders =await reminderDao.findRepeatedReminderByDay(DateTime.saturday);
    cyclicEvents[6]= saturdayRepeatedReminders;
    final sundayRepeatedReminders =await reminderDao.findRepeatedReminderByDay(DateTime.sunday);
    cyclicEvents[7]= sundayRepeatedReminders;
    return;
  }


  @override
  void initState() {
    super.initState();
    setState(() {
          _selectedDay = _focusedDay;
    });
    getDayReminders(_selectedDay!).then((value){
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
      getDayReminders(_selectedDay!).then((value){
        setState(() {
          _selectedEvents = value;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget detailsButton = TextButton(
      style: TextButton.styleFrom(
        primary: Colors.black,
        //backgroundColor: MyColors.TealBlue,
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

    return PageLayout(
      appBarTitle: "Calender",
      child: Column(
        children: [
          TableCalendar(
            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(
                  color: MyColors.TealBlue, shape: BoxShape.circle),
              todayDecoration: BoxDecoration(
                  color: MyColors.TealBlue.withOpacity(0.5),
                  shape: BoxShape.circle),
            ),
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2050, 1, 1),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            onDaySelected: _onDaySelected,

            selectedDayPredicate: (day) {
              // Use `selectedDayPredicate` to determine which day is currently selected.
              // If this returns true, then `day` will be marked as selected.

              // Using `isSameDay` is recommended to disregard
              // the time-part of compared DateTime objects.
              return isSameDay(_selectedDay, day);
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                // Call `setState()` when updating calendar format
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              // No need to call `setState()` here
              _focusedDay = focusedDay;
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [Image.asset('assets/pill.png', height: 60, width: 80)],
          ),
        ],
      ),
      containerChild: ListView(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              DateCard(_focusedDay),
              detailsButton,
            ],
          ),
          SizedBox(height: 32),
          Row(
            children: [
              Text(
                'YOUR PLAN PROGRESS ',
                style: TextStyle(
                    fontSize: 18, letterSpacing: 1, fontFamily: 'Raleway'),
              ),
              Column(
                children: _selectedEvents
                    .map((reminderItem) => Text('${reminderItem.label}'))
                    .toList(),
              )
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              // new LinearPercentIndicator(
              //   width:  MediaQuery.of(context).size.width - 60 ,
              //   lineHeight: 10.0,
              //   percent: 0.1,
              //   backgroundColor: MyColors.Landing2,
              //   progressColor: MyColors.TealBlue,
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
