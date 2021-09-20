import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pill_pal/components/pageSecondLayout.dart';
//import 'package:pill_pal/dao/medicine_dao.dart';
import 'package:pill_pal/dao/reminder_dao.dart';
import 'package:pill_pal/entities/reminder.dart';
import 'package:pill_pal/pages/calender/components/dateCard.dart';
import 'package:pill_pal/theme.dart';
import 'package:table_calendar/table_calendar.dart';

class Calender extends StatefulWidget {
  const Calender({
    Key? key,
    required this.reminderDao,
    //required this.medicineDao
  }) : super(key: key);


  final ReminderDao reminderDao;

  @override
  _CalenderState createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  List<Reminder> _selectedEvents = [];
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  var cyclicEvents = new Map();
  Map timeMap = new Map();


  Future<List<Reminder>> getDayReminders(DateTime date) async {
    final reminders = await widget.reminderDao.findReminderByDate(
        DateTime(date.year, date.month, date.day).toString());
    if(!cyclicEvents.containsKey(date.weekday)) {
      final dayRepeatedReminders = await widget.reminderDao.findRepeatedReminderByDay(date.weekday);
      cyclicEvents[date.weekday] = dayRepeatedReminders;
    }
    reminders.addAll(cyclicEvents[date.weekday] ?? []);
    return reminders;
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
        _selectedEvents.sort((a,b)=> DateTime(1,1,1999,a.dateTime.hour, a.dateTime.minute).compareTo(DateTime(1,1,1999,b.dateTime.hour, b.dateTime.minute)));
      });
      //getMedicinesById(_selectedEvents).then((value) => null);
    });
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
          _selectedEvents.sort((a,b)=> DateTime(1,1,1999,a.dateTime.hour, a.dateTime.minute).compareTo(DateTime(1,1,1999,b.dateTime.hour, b.dateTime.minute)));
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
   final defaultPadding = MediaQuery. of(context). size. width / 20;
   setState(() {
     timeMap.clear();
   });

    return PageSecondLayout(
      appBarTitle: "My Calender",
      color: MyColors.Landing1,
      showFAB: false,
      topChild: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TableCalendar(
            headerStyle: HeaderStyle(
              formatButtonShowsNext: false,
            ),
            availableCalendarFormats: const {CalendarFormat.month : 'Month',CalendarFormat.week : 'Week'},
            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(
                  color: MyColors.TealBlue, shape: BoxShape.circle),
              todayDecoration: BoxDecoration(
                  color: MyColors.TealBlue.withOpacity(0.5),
                  shape: BoxShape.circle),
            ),
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.now().add(Duration(days: 7300)),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            onDaySelected: _onDaySelected,

            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [Image.asset('assets/pill.png', height: 60, width: 80)],
          ),
        ],
      ),
      containerChild: Padding(
        padding: EdgeInsets.fromLTRB(defaultPadding, defaultPadding, 0,0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                DateCard(_focusedDay),
                TextButton(
                  child: Row(
                    children: [
                      Text("Checklist",
                        style: TextStyle(color: Colors.black, fontSize: 16)
                      ),
                      Icon(
                        Icons.double_arrow_outlined,
                        size: 16,
                      ),
                    ],
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/day_reminders',
                        arguments: {
                          'dateTime': _focusedDay,
                          'reminders': _selectedEvents
                        });
                  },
                ),
              ],
            ),
            SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _selectedEvents
                      .map((reminderItem) {
                        return getReminderRow(reminderItem);
                      }).toList(),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Row getReminderRow(Reminder reminderItem) {
    var time = '${reminderItem.dateTime.hour < 10? '0': ''}${reminderItem.dateTime.hour}:'
        '${reminderItem.dateTime.minute < 10? '0': ''}${reminderItem.dateTime.minute}';
    setState(() {
      timeMap.containsKey(time)? timeMap[time]+=1 : timeMap[time] =1;
    });
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: 75,
              ),
              child:
              Text('${timeMap[time] ==1? time : ''}',
                style: TextStyle(fontSize: 18, color: MyColors.TealBlue, fontWeight: FontWeight.bold),
              ),

            ),
            SizedBox(height: 24,),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(width: 3.0, color: MyColors.MiddleBlueGreen),
            ),
            color: Colors.white,
          ),
          child: Text('   ${reminderItem.medicineName}', style: TextStyle(fontSize: 18),),
        ),

      ],
    );
  }
}


