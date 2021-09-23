import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pill_pal/components/pageSecondLayout.dart';
import 'package:pill_pal/dao/medicine_dao.dart';
import 'package:pill_pal/dao/reminder_check_dao.dart';
import 'package:pill_pal/dao/reminder_dao.dart';
import 'package:pill_pal/entities/medicine.dart';
import 'package:pill_pal/entities/reminder.dart';
import 'package:pill_pal/entities/reminderCheck.dart';
import 'package:pill_pal/pages/calender/components/dateCard.dart';
import 'package:pill_pal/theme.dart';
import 'package:pill_pal/util/notificationUtil.dart';
import 'package:table_calendar/table_calendar.dart';

class Calender extends StatefulWidget {
  const Calender(
      {Key? key,
      required this.medicineDao,
      required this.reminderDao,
      required this.reminderCheckDao,
      this.passedDay,
      })
      : super(key: key);

  final MedicineDao medicineDao;
  final ReminderDao reminderDao;
  final ReminderCheckDao reminderCheckDao;
  final DateTime? passedDay;

  @override
  _CalenderState createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  List<Reminder> _selectedEvents = [];
  //Map cyclicEvents = new Map();
  List<List<dynamic>> _checkList = [];
  Map timeMap = new Map();
  Medicine? med;

  //bool rebuiltHomeFlag = false;

  Future<List<Reminder>> getDayReminders(DateTime date) async {
    final reminders = widget.reminderDao.findReminderForDay(
        DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day).toString()
        , _selectedDay!.weekday);
    // final reminders = await widget.reminderDao.findReminderByDate(
    //     DateTime(date.year, date.month, date.day).toString());
    // if (!cyclicEvents.containsKey(date.weekday)) {
    //   final dayRepeatedReminders =
    //       await widget.reminderDao.findRepeatedReminderByDay(date.weekday);
    //   cyclicEvents[date.weekday] = dayRepeatedReminders;
    // }
    // reminders.addAll(cyclicEvents[date.weekday] ?? []);
    return reminders;
  }

  Future<void> getCheckList() async {
    _checkList.clear();
    _selectedEvents.forEach((reminder) {
      var scheduledDateTime = DateTime(_selectedDay!.year, _selectedDay!.month,
          _selectedDay!.day, reminder.dateTime.hour, reminder.dateTime.minute);
      widget.reminderCheckDao
          .findReminderByScheduledDate(scheduledDateTime, reminder.id ?? 0)
          .then((reminderCheck) {
        if (reminderCheck == null) {
          setState(() {
            _checkList.add([reminder, false]);
          });
        } else {
          setState(() {
            _checkList.add([reminder, true, reminderCheck]);
          });
        }
      });
    });
    return;
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
          _selectedEvents.sort((a, b) => DateTime(
                  1, 1, 1999, a.dateTime.hour, a.dateTime.minute)
              .compareTo(
                  DateTime(1, 1, 1999, b.dateTime.hour, b.dateTime.minute)));
        });
        getCheckList().then((value) => null);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _selectedDay = widget.passedDay ?? _focusedDay;
    });
    getDayReminders(_selectedDay!).then((value) {
      setState(() {
        _selectedEvents = value;
        _selectedEvents.sort((a, b) =>
            DateTime(1, 1, 1999, a.dateTime.hour, a.dateTime.minute).compareTo(
                DateTime(1, 1, 1999, b.dateTime.hour, b.dateTime.minute)));
      });
      getCheckList().then((value) => null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final defaultPadding = MediaQuery.of(context).size.width / 20;
    setState(() {
      timeMap.clear();
    });

    return PageSecondLayout(
      appBarTitle: "My Reminders",
      color: MyColors.Landing1,
      // appBarLeading: IconButton(
      //   onPressed: () {
      //     goToHome(context);
      //   },
      //   icon: Icon(
      //     Icons.arrow_back,
      //   ),
      // ),
      topChild: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TableCalendar(
            headerStyle: HeaderStyle(
              formatButtonShowsNext: false,
              titleTextStyle : Theme.of(context).textTheme.bodyText2!,
              formatButtonTextStyle: Theme.of(context).textTheme.overline!,
            ),
            availableCalendarFormats: const {
              CalendarFormat.month: 'Month',
              CalendarFormat.week: 'Week'
            },
            daysOfWeekStyle :  DaysOfWeekStyle(
                weekdayStyle: Theme.of(context).textTheme.caption!.copyWith(color: Colors.black),
                weekendStyle: Theme.of(context).textTheme.caption!.copyWith(color: Colors.black),
            ),
            calendarStyle: CalendarStyle(
              defaultTextStyle: Theme.of(context).textTheme.bodyText2!,
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
          SizedBox(
            height: 32,
          )
        ],
      ),
      containerChild: Padding(
        padding: EdgeInsets.fromLTRB(defaultPadding, defaultPadding, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DateCard(_selectedDay),
            SizedBox(height: 32),
            _checkList.isEmpty?
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text('No Reminders Today', style: TextStyle(color: Colors.black54),),
              ),
            ) :
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _checkList.asMap().entries.map((checkItem) {
                      return getReminderRow(checkItem.value, checkItem.key);
                    }).toList(),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  // void goToHome(BuildContext context) {
  //   if (rebuiltHomeFlag) {
  //     Navigator.pushNamedAndRemoveUntil(
  //         context, '/home', (route) => false);
  //   } else {
  //     Navigator.pop(context);
  //   }
  // }

  GestureDetector getReminderRow(List<dynamic> checkItem, int index) {
    Reminder reminder = checkItem[0];
    bool isChecked = checkItem[1];
    ReminderCheck? reminderCheck;
    reminderCheck = 2 < checkItem.length ? checkItem[2] : null;

    var now = DateTime.now();
    var scheduledDateTime = DateTime(_selectedDay!.year, _selectedDay!.month,
        _selectedDay!.day, reminder.dateTime.hour, reminder.dateTime.minute);

    // determine reminder check icon
    Widget icon = Icon(Icons.do_disturb_on_outlined, color: Colors.grey);
    if (isChecked) {
      icon = Icon(
        Icons.task_alt,
        color: MyColors.TealBlue,
      );
    }

    // to show time only once
    var time =
        '${reminder.dateTime.hour < 10 ? '0' : ''}${reminder.dateTime.hour}:'
        '${reminder.dateTime.minute < 10 ? '0' : ''}${reminder.dateTime.minute}';
    setState(() {
      timeMap.containsKey(time) ? timeMap[time] += 1 : timeMap[time] = 1;
    });

    return GestureDetector(
      onTap: () {
        setState(() {
          med = null;
        });
        showModalBottomSheet<void>(
          context: context,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(MediaQuery.of(context).size.width / 20),
          ),
          builder: (BuildContext context) {
            return Container(
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width / 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      isChecked
                          ? Container()
                          : TextButton.icon(
                              style: TextButton.styleFrom(
                                primary: Colors.black,
                                textStyle:
                                    Theme.of(context).textTheme.bodyText1,
                              ),
                              label: Text('Check Dose'),
                              icon: Icon(
                                Icons.task_alt,
                              ),
                              onPressed: () {
                                if (med == null) {
                                  widget.medicineDao
                                      .findMedicineById(reminder.medicineId)
                                      .then((medicineItem) {
                                    setState(() {
                                      med = medicineItem;
                                    });
                                    takeDose(medicineItem, reminder,
                                        scheduledDateTime, now, index, context);
                                  });
                                } else {
                                  takeDose(med, reminder, scheduledDateTime,
                                      now, index, context);
                                }
                              },
                            ),
                      !isChecked
                          ? Container()
                          : TextButton.icon(
                              style: TextButton.styleFrom(
                                primary: Colors.black,
                                textStyle:
                                    Theme.of(context).textTheme.bodyText1,
                              ),
                              label: Text('Uncheck Dose'),
                              icon: Icon(
                                Icons.highlight_off,
                              ),
                              onPressed: () {
                                if (med == null) {
                                  widget.medicineDao
                                      .findMedicineById(reminder.medicineId)
                                      .then((medicineItem) {
                                    setState(() {
                                      med = medicineItem;
                                    });
                                    unTakeDose(medicineItem, index, context);
                                  });
                                } else {
                                  unTakeDose(med, index, context);
                                }
                              },
                            ),
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          primary: Colors.black,
                          textStyle: Theme.of(context).textTheme.bodyText1,
                        ),
                        label: Text('Medicine Info'),
                        icon: Icon(
                          Icons.medication,
                        ),
                        onPressed: () {
                          goToMedicinePage(reminder, context);
                        },
                      ),
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          primary: Colors.black,
                          textStyle: Theme.of(context).textTheme.bodyText1,
                        ),
                        label: Text('Delete Reminder'),
                        icon: Icon(
                          Icons.delete,
                        ),
                        onPressed: () {
                          showDeleteDialog(reminder, index, context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
      child: Column(
        children: [
          Row(
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
                    child: Text(
                      '${timeMap[time] == 1 ? time : ''}',
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: MyColors.TealBlue,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                          width: 3.0, color: MyColors.MiddleBlueGreen),
                    ),
                    color: Colors.white,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 8,
                      ),
                      icon,
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${reminder.medicineName}',
                            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontWeight: FontWeight.bold),
                            ),
                            reminder.repeated
                                ? Text(
                              'Every ${DateFormat('EEEE').format(reminder.dateTime)}',
                              style: Theme.of(context).textTheme.caption!.copyWith(
                                  color: Colors.black54),
                            )
                                : Text(
                              'Once',
                              style: Theme.of(context).textTheme.caption!.copyWith(
                                  color: Colors.black54),
                            ),
                            isChecked
                                ? Text(
                                '${DateFormat('dd/MM/yyyy  kk:mm').format(reminderCheck!.checkedDateTime)}',
                                  style: Theme.of(context).textTheme.caption!,
                                  )
                                : reminder.label.isNotEmpty
                                ? Text(
                              '${reminder.label}',
                              softWrap: true,
                              style: Theme.of(context).textTheme.caption!,
                            )
                                : Container(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          )
        ],
      ),
    );
  }

  void showDeleteDialog(Reminder reminder, int index, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
              child: Text('This reminder will be permanently deleted.',
                style: TextStyle(fontSize: 14),)),
          actions: [
            TextButton(
              child: Text(
                "Delete",
                style: TextStyle(fontSize: 14),
              ),
              onPressed: () {
                onDeleteReminder(reminder, index, context);
              },
            ),
            TextButton(
              child: Text(
                "Cancel",
                style: TextStyle(fontSize: 14),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void onDeleteReminder(Reminder reminder, int index, BuildContext context) {
    //if date is today, rebuild home screen
    // final now = new DateTime.now();
    // if (DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day)
    //     .isAtSameMomentAs(DateTime(now.year, now.month, now.day))) {
    //   setState(() {
    //     rebuiltHomeFlag = true;
    //   });
    // }

    widget.reminderDao.deleteReminder(reminder).then((value) {
      setState(() {
        _checkList.removeAt(index);
      });
      cancelNotification(reminder.id ?? 0);
      Navigator.pop(context);
      Navigator.pop(context);
    });
  }

  void goToMedicinePage(Reminder reminder, BuildContext context) {
    if (med == null) {
      widget.medicineDao
          .findMedicineById(reminder.medicineId)
          .then((medicineItem) {
        setState(() {
          med = medicineItem;
        });
        Navigator.pushNamed(context, '/medicine_item', arguments: medicineItem);
      });
    } else {
      Navigator.pushNamed(context, '/medicine_item', arguments: med);
    }
  }

  void done(Reminder reminder, DateTime scheduledDateTime, DateTime now,
      int index, BuildContext context) {
    // //if date is today, rebuild home screen
    // final now = new DateTime.now();
    // if (DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day)
    //     .isAtSameMomentAs(DateTime(now.year, now.month, now.day))) {
    //   setState(() {
    //     rebuiltHomeFlag = true;
    //   });
    // }

    int timestamp = DateTime.now().millisecondsSinceEpoch;
    int checkId = timestamp ~/ 1000 + timestamp % 1000;
    ReminderCheck check = ReminderCheck(
        id: checkId,
        reminderId: reminder.id,
        scheduledDateTime: scheduledDateTime,
        checkedDateTime: now);
    widget.reminderCheckDao.insertReminderCheck(check).then((value) {
      setState(() {
        _checkList[index][1] = true;
        2 < _checkList[index].length
            ? _checkList[index][2] = check
            : _checkList[index].add(check);
      });
      Navigator.pop(context);
    });
  }

  void takeDose(
      Medicine? medicineItem,
      Reminder reminder,
      DateTime scheduledDateTime,
      DateTime now,
      int index,
      BuildContext context) {
    if (medicineItem!.supplyCurrent >= medicineItem.dose) {
      medicineItem = medicineItem.copyWith(
          supplyCurrent: medicineItem.supplyCurrent - medicineItem.dose);
      widget.medicineDao.updateMedicine(medicineItem).then((value) {
        done(reminder, scheduledDateTime, now, index, context);
      });
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${medicineItem.name} supply is empty')),
      );
    }

    if (medicineItem.supplyCurrent == 0) {
      singleNotificationCallback(
              1,
              '${medicineItem.name} Refill',
              'current supply empty.',
              DateTime.now(),
              'medicine ${medicineItem.id}',
              sound: 'happy_tone_short')
          .then((value) => null);
    } else if (medicineItem.supplyCurrent <= medicineItem.supplyMin) {
      singleNotificationCallback(
              1,
              '${medicineItem.name} Refill',
              'current supply running out.',
              DateTime.now(),
              'medicine ${medicineItem.id}',
              sound: 'happy_tone_short')
          .then((value) => null);
    }
  }

  void unDone(int index, BuildContext context) {
    // //if date is today, rebuild home screen
    // final now = new DateTime.now();
    // if (DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day)
    //     .isAtSameMomentAs(DateTime(now.year, now.month, now.day))) {
    //   setState(() {
    //     rebuiltHomeFlag = true;
    //   });
    // }

    ReminderCheck check = _checkList[index][2];
    widget.reminderCheckDao.deleteReminderCheck(check).then((value) {
      setState(() {
        _checkList[index][1] = false;
        _checkList[index].removeAt(2);
      });
      Navigator.pop(context);
    });
  }

  void unTakeDose(Medicine? medicineItem, int index, BuildContext context) {
    medicineItem = medicineItem!.copyWith(
        supplyCurrent: medicineItem.supplyCurrent + medicineItem.dose);
    widget.medicineDao.updateMedicine(medicineItem).then((value) {
      unDone(index, context);
    });
  }
}
