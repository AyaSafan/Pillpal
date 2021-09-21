import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pill_pal/components/pageSecondLayout.dart';
import 'package:pill_pal/dao/reminder_check_dao.dart';
import 'package:pill_pal/dao/reminder_dao.dart';
import 'package:pill_pal/entities/reminder.dart';
import 'package:pill_pal/entities/reminderCheck.dart';
import 'package:pill_pal/pages/Home/components/CustomCard.dart';
import 'package:pill_pal/pages/calender/components/dateCard.dart';
import 'package:pill_pal/theme.dart';

class Home extends StatefulWidget {
  const Home({
    Key? key,
    required this.reminderDao,
    required this.reminderCheckDao,
  }) : super(key: key);

  final ReminderDao reminderDao;
  final ReminderCheckDao reminderCheckDao;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DateTime _selectedDay =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  List<Reminder> _selectedEvents = [];
  List<List<dynamic>> checkList =
      []; //[ [reminder object, bool checked or not, reminderCheck object if exists] ]
  Map timeMap = new Map();

  Future<List<Reminder>> getDayReminders(DateTime date) async {
    final reminders = await widget.reminderDao.findReminderByDate(
        DateTime(date.year, date.month, date.day).toString());
    final dayRepeatedReminders =
        await widget.reminderDao.findRepeatedReminderByDay(date.weekday);
    reminders.addAll(dayRepeatedReminders);
    return reminders;
  }

  Future<void> getCheckList() async {
    checkList.clear();
    _selectedEvents.forEach((reminder) {
      var scheduledDateTime = DateTime(_selectedDay.year, _selectedDay.month,
          _selectedDay.day, reminder.dateTime.hour, reminder.dateTime.minute);
      widget.reminderCheckDao
          .findReminderByScheduledDate(scheduledDateTime, reminder.id ?? 0)
          .then((reminderCheck) {
        if (reminderCheck == null) {
          setState(() {
            checkList.add([reminder, false]);
          });
        } else {
          setState(() {
            checkList.add([reminder, true, reminderCheck]);
          });
        }
      });
    });
    return;
  }

  @override
  void initState() {
    super.initState();
    getDayReminders(_selectedDay).then((value) {
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
    return PageSecondLayout(
      toolbarHeight: 30,
      topChild: Padding(
        padding: EdgeInsets.all(defaultPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                goToCalender(context);
              },
              child: CustomCard(
                icon: Image.asset(
                  'assets/calender.png',
                  width: 80,
                ),
                title: 'Reminders',
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/cabinet');
              },
              child: CustomCard(
                icon: Image.asset(
                  'assets/cabinet.png',
                  width: 80,
                ),
                title: 'Cabinet',
              ),
            ),
          ],
        ),
      ),
      containerChild: Padding(
        padding: EdgeInsets.fromLTRB(defaultPadding, defaultPadding, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DateCard(_selectedDay),
            SizedBox(height: 32),
            GestureDetector(
              onTap: () {
                goToCalender(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: checkList.asMap().entries.map((checkItem) {
                        return getReminderRow(checkItem.value, checkItem.key);
                      }).toList(),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void goToCalender(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
        context, '/calender', ModalRoute.withName('/home'),
        arguments: {
          'passedDay': _selectedDay,
          'selectedEvents': _selectedEvents,
          'checkList': checkList
        });
  }

  Column getReminderRow(List<dynamic> checkItem, int index) {
    Reminder reminder = checkItem[0];
    bool isChecked = checkItem[1];
    ReminderCheck? reminderCheck;
    reminderCheck = 2 < checkItem.length ? checkItem[2] : null;

    // determine reminder check icon
    Widget icon = Icon(Icons.panorama_fish_eye, color: Colors.grey);
    var now = DateTime.now();
    var scheduledDateTime = DateTime(_selectedDay.year, _selectedDay.month,
        _selectedDay.day, reminder.dateTime.hour, reminder.dateTime.minute);
    if (isChecked) {
      icon = Icon(
        Icons.task_alt,
        color: MyColors.TealBlue,
      );
    } else if (scheduledDateTime.add(Duration(minutes: 5)).isBefore(now)) {
      icon = Icon(
        Icons.highlight_off,
        color: MyColors.MiddleRed,
      );
    }

    // to show time only once
    var time =
        '${reminder.dateTime.hour < 10 ? '0' : ''}${reminder.dateTime.hour}:'
        '${reminder.dateTime.minute < 10 ? '0' : ''}${reminder.dateTime.minute}';
    setState(() {
      timeMap.containsKey(time) ? timeMap[time] += 1 : timeMap[time] = 1;
    });

    return Column(
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
                    style: TextStyle(
                        fontSize: 18,
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
                    left:
                        BorderSide(width: 3.0, color: MyColors.MiddleBlueGreen),
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
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          reminder.repeated
                              ? Text(
                                  'Every ${DateFormat('EEEE').format(reminder.dateTime)}',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black54),
                                )
                              : Text(
                                  'Once',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black54),
                                ),
                          isChecked
                              ? Text(
                                  '${DateFormat('dd/MM/yyyy  kk:mm').format(reminderCheck!.checkedDateTime)}')
                              : reminder.label.isNotEmpty
                                  ? Text(
                                      '${reminder.label}',
                                      softWrap: true,
                                      style: TextStyle(fontSize: 16),
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
    );
  }
}
