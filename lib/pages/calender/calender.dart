import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pill_pal/components/pageSecondLayout.dart';
import 'package:pill_pal/dao/medicine_dao.dart';
import 'package:pill_pal/dao/reminder_dao.dart';
import 'package:pill_pal/entities/reminder.dart';
import 'package:pill_pal/pages/calender/components/dateCard.dart';
import 'package:pill_pal/pages/calender/components/detailsButton.dart';
import 'package:pill_pal/theme.dart';
import 'package:table_calendar/table_calendar.dart';

class Calender extends StatefulWidget {
  const Calender({
    Key? key,
    required this.reminderDao,
    required this.medicineDao
  }) : super(key: key);


  final ReminderDao reminderDao;
  final MedicineDao medicineDao;

  @override
  _CalenderState createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  List<Reminder> _selectedEvents = [];
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  var cyclicEvents = new Map();
  var medNames = new Map();


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

  //reconsider
  Future<void> getMedicinesById(List<Reminder> reminders) async {
    reminders.forEach((reminder) async {
      final med = await widget.medicineDao.findMedicineById(reminder.medicineId);
      medNames[reminder.id] = med?.name;
    });
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
      //reconsider
      getMedicinesById(_selectedEvents).then((value) => null);
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
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
   final defaultPadding = MediaQuery. of(context). size. width / 20;

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
      containerChild: Padding(
        padding: EdgeInsets.fromLTRB(defaultPadding, defaultPadding, 0,0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                DateCard(_focusedDay),
                DetailsButton(_focusedDay),
              ],
            ),
            SizedBox(height: 32),
            Row(
              children: [
                Column(
                  children: _selectedEvents
                      .map((reminderItem) =>
                      Row(
                        children: [
                          Column(
                            children: [
                              ConstrainedBox(
                                constraints: const BoxConstraints(
                                  minWidth: 75,
                                ),
                                child: Text('${reminderItem.dateTime.hour < 10? '0': ''}${reminderItem.dateTime.hour} :'
                                    '${reminderItem.dateTime.minute < 10? '0': ''}${reminderItem.dateTime.minute}'),

                              )
                            ],
                          ),
                          Text('${medNames[reminderItem.id]}')
                        ],
                      )
                      )
                      .toList(),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CalenderReminderRow extends StatelessWidget {
  const CalenderReminderRow(this.reminderItem, {
    Key? key,
  }) : super(key: key);

  final Reminder reminderItem;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: 75,
              ),
              child: Text('${reminderItem.dateTime.hour < 10? '0': ''}${reminderItem.dateTime.hour} :'
                          '${reminderItem.dateTime.minute < 10? '0': ''}${reminderItem.dateTime.minute}'),

            )
          ],
        ),
        Text('${reminderItem.label}')
      ],
    );
  }
}
