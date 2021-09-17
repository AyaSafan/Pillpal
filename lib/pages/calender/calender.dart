import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pill_pal/components/pageSecondLayout.dart';
import 'package:pill_pal/dao/reminder_dao.dart';
import 'package:pill_pal/entities/reminder.dart';
import 'package:pill_pal/pages/calender/components/dateCard.dart';
import 'package:pill_pal/pages/calender/components/detailsButton.dart';
import 'package:pill_pal/theme.dart';
import 'package:table_calendar/table_calendar.dart';

class Calender extends StatefulWidget {
  const Calender({
    Key? key,
    required this.reminderDao
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
      });
    });

    //getRepeatedReminders().then((value) => null);
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


    return PageSecondLayout(
      appBarTitle: "My Calender",
      color: MyColors.Landing1,
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
            lastDay: DateTime.utc(2050, 1, 1),
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
      containerChild: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              DateCard(_focusedDay),
              DetailsButton(),
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
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Column(
                children: _selectedEvents
                    .map((reminderItem) => Text('${reminderItem.label}'))
                    .toList(),
              )
            ],
          ),
        ],
      ),
    );
  }
}
