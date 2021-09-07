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
  List<Reminder> allReminders =[];
  List<Reminder> _selectedEvents =[];
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  Future<List<Reminder>> getAllReminders() async{
    final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    final reminderDao = database.reminderDao;
    final result = await reminderDao.findAllReminders();
    return result;
}
  List<Reminder> _getEventsForDay(DateTime day) {
    List<Reminder> events =  [];
    for(var i=0; i<allReminders.length; i++){
      if (isSameDay(allReminders[i].dateTime, day)){
        events= [...events, allReminders[i]] ;
      }
    }
    return events;
  }

  @override
  void initState() {
    super.initState();
    getAllReminders().then((value) {
        setState(() {
          allReminders = value;
        });
        setState(() {
          _selectedDay = _focusedDay;
          _selectedEvents=_getEventsForDay(_selectedDay!);
        });
    });




  }


  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _focusedDay = focusedDay;
        _selectedDay = selectedDay;
        _selectedEvents=_getEventsForDay(_selectedDay!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    Widget detailsButton =
    TextButton(
      style: TextButton.styleFrom(
        primary: Colors.black,
        //backgroundColor: MyColors.TealBlue,
        padding: EdgeInsets.only(bottom: 0),
        alignment: Alignment.bottomLeft,
        textStyle: const TextStyle(fontSize: 15, letterSpacing: 1, fontFamily: 'Raleway'),
      ),
      onPressed: () {
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

    return PageLayout(
      appBarTitle: "Calender",
      child: Column(
        children: [
          TableCalendar(
            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(color: MyColors.TealBlue, shape: BoxShape.circle),
              todayDecoration:  BoxDecoration(color: MyColors.TealBlue.withOpacity(0.5), shape: BoxShape.circle),
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
            // onDaySelected: (selectedDay, focusedDay) {
            //   if (!isSameDay(_selectedDay, selectedDay)) {
            //     // Call `setState()` when updating the selected day
            //     setState(() {
            //       _selectedDay = selectedDay;
            //       _focusedDay = focusedDay;
            //     });
            //   }
            // },
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
            children: [
              Image.asset('assets/pill.png', height: 60, width: 80)
            ],
          ),
        ],
      ),
      containerChild:  ListView(
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
                style: TextStyle(fontSize: 18, letterSpacing: 1, fontFamily: 'Raleway'),
              ),
              Column(
                children: _selectedEvents.map((reminderItem) => Text('${reminderItem.label}')).toList(),
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


