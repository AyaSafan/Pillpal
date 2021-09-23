import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:pill_pal/components/pageFirstLayout.dart';
import 'package:pill_pal/dao/reminder_check_dao.dart';
import 'package:pill_pal/dao/reminder_dao.dart';
import 'package:pill_pal/entities/reminder.dart';
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
  List<List<dynamic>> _checkList = [];
  Map timeMap = new Map();

  // Future<List<Reminder>> getDayReminders(DateTime date) async {
  //   final reminders = await widget.reminderDao.findReminderByDate(
  //       DateTime(date.year, date.month, date.day).toString());
  //   final dayRepeatedReminders =
  //       await widget.reminderDao.findRepeatedReminderByDay(date.weekday);
  //   reminders.addAll(dayRepeatedReminders);
  //   return reminders;
  // }

  Stream<List<List<Reminder>>> getDayRemindersAsStream()  {
    final reminders = widget.reminderDao.findReminderByDateAsStream(
        DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day).toString());
    final dayRepeatedReminders = widget.reminderDao.findRepeatedReminderByDayAsStream(_selectedDay.weekday);

    return StreamZip([reminders, dayRepeatedReminders]);
  }

  // Future<void> getCheckList() async {
  //   _checkList.clear();
  //   _selectedEvents.forEach((reminder) {
  //     var scheduledDateTime = DateTime(_selectedDay.year, _selectedDay.month,
  //         _selectedDay.day, reminder.dateTime.hour, reminder.dateTime.minute);
  //     widget.reminderCheckDao
  //         .findReminderByScheduledDate(scheduledDateTime, reminder.id ?? 0)
  //         .then((reminderCheck) {
  //       if (reminderCheck == null) {
  //         setState(() {
  //           _checkList.add([reminder, false]);
  //         });
  //       } else {
  //         setState(() {
  //           _checkList.add([reminder, true, reminderCheck]);
  //         });
  //       }
  //     });
  //   });
  //   return;
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   getDayReminders(_selectedDay).then((value) {
  //     setState(() {
  //       _selectedEvents = value;
  //       _selectedEvents.sort((a, b) =>
  //           DateTime(1, 1, 1999, a.dateTime.hour, a.dateTime.minute).compareTo(
  //               DateTime(1, 1, 1999, b.dateTime.hour, b.dateTime.minute)));
  //     });
  //     getCheckList().then((value) => null);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final defaultPadding = MediaQuery.of(context).size.width / 20;

    return PageFirstLayout(
      appBarRight: Container(
        margin: EdgeInsets.all(defaultPadding),
        child: IconButton(
          icon: Icon(Icons.more_vert, size: 30, color: MyColors.TealBlue,),
          onPressed: (){
            showModalBottomSheet<void>(
              context: context,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(defaultPadding),
              ),
              builder: buildBottomSheet,
            );
          },
        ),
      ) ,
      topChild: Padding(
        padding: EdgeInsets.fromLTRB(defaultPadding,0,defaultPadding,defaultPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
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
          ],
        ),
      ),
      containerChild: Padding(
        padding: EdgeInsets.fromLTRB(defaultPadding, defaultPadding, 0, 0),
        child: ListView(
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
                    child: StreamBuilder<List<List<Reminder>>>(
                      stream: getDayRemindersAsStream(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('error');
                        }
                        if (!snapshot.hasData) return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Text('No Reminders Today', style: TextStyle(color: Colors.black54),),
                          ),
                        );

                        List<List<Reminder>> querySnapshotData =  snapshot.data!.toList();
                        List<Reminder> reminders =  querySnapshotData[0];
                        reminders.addAll( querySnapshotData[1]);
                        reminders.sort((a, b) =>
                              DateTime(1, 1, 1999, a.dateTime.hour, a.dateTime.minute).compareTo(
                                  DateTime(1, 1, 1999, b.dateTime.hour, b.dateTime.minute)));

                        timeMap.clear();
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: reminders.asMap().entries.map((reminder) {
                            return getReminderRow(reminder.value);
                          }).toList(),
                        );

                      }
                    )
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: _checkList.asMap().entries.map((checkItem) {
                    //     return getReminderRow(checkItem.value, checkItem.key);
                    //   }).toList(),
                    // ),
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
        arguments:  _selectedDay,
        );
  }

  Widget buildBottomSheet(BuildContext context) {
    return Container(
      child:
      SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(MediaQuery. of(context). size. width / 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton.icon(
                style: TextButton.styleFrom(
                  primary: Colors.black,
                  textStyle: Theme.of(context).textTheme.bodyText1,
                ),
                label: Text('Add Reminder'),
                icon: Icon(
                  Icons.notification_add,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/reminder_add');
                },
              ),
              TextButton.icon(
                style: TextButton.styleFrom(
                  primary: Colors.black,
                  textStyle: Theme.of(context).textTheme.bodyText1,
                ),
                label: Text('Add Medicine'),
                icon: Icon(
                  Icons.medication,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/medicine_add');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row getReminderRow(Reminder reminderItem) {
    var time = '${reminderItem.dateTime.hour < 10? '0': ''}${reminderItem.dateTime.hour}:'
        '${reminderItem.dateTime.minute < 10? '0': ''}${reminderItem.dateTime.minute}';
      timeMap.containsKey(time)? timeMap[time]+=1 : timeMap[time] =1;
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

  // Column getReminderRow(List<dynamic> checkItem, int index) {
  //   Reminder reminder = checkItem[0];
  //   bool isChecked = checkItem[1];
  //   ReminderCheck? reminderCheck;
  //   reminderCheck = 2 < checkItem.length ? checkItem[2] : null;
  //
  //   // determine reminder check icon
  //   Widget icon = Icon(Icons.do_disturb_on_outlined, color: Colors.grey);
  //   if (isChecked) {
  //     icon = Icon(
  //       Icons.task_alt,
  //       color: MyColors.TealBlue,
  //     );
  //   }
  //
  //   // to show time only once
  //   var time =
  //       '${reminder.dateTime.hour < 10 ? '0' : ''}${reminder.dateTime.hour}:'
  //       '${reminder.dateTime.minute < 10 ? '0' : ''}${reminder.dateTime.minute}';
  //   setState(() {
  //     timeMap.containsKey(time) ? timeMap[time] += 1 : timeMap[time] = 1;
  //   });
  //
  //   return Column(
  //     children: [
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               ConstrainedBox(
  //                 constraints: const BoxConstraints(
  //                   minWidth: 75,
  //                 ),
  //                 child: Text(
  //                   '${timeMap[time] == 1 ? time : ''}',
  //                   style: Theme.of(context).textTheme.subtitle1!.copyWith(
  //                       color: MyColors.TealBlue,
  //                       fontWeight: FontWeight.bold),
  //                 ),
  //               ),
  //             ],
  //           ),
  //           Expanded(
  //             child: Container(
  //               decoration: BoxDecoration(
  //                 border: Border(
  //                   left:
  //                       BorderSide(width: 3.0, color: MyColors.MiddleBlueGreen),
  //                 ),
  //                 color: Colors.white,
  //               ),
  //               child: Row(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   SizedBox(
  //                     width: 8,
  //                   ),
  //                   icon,
  //                   SizedBox(
  //                     width: 8,
  //                   ),
  //                   Expanded(
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Text(
  //                           '${reminder.medicineName}',
  //                           style: Theme.of(context).textTheme.bodyText1!.copyWith(
  //                               fontWeight: FontWeight.bold),
  //                         ),
  //                         reminder.repeated
  //                             ? Text(
  //                           'Every ${DateFormat('EEEE').format(reminder.dateTime)}',
  //                           style: Theme.of(context).textTheme.caption!.copyWith(
  //                               color: Colors.black54),
  //                         )
  //                             : Text(
  //                           'Once',
  //                           style: Theme.of(context).textTheme.caption!.copyWith(
  //                               color: Colors.black54),
  //                         ),
  //                         isChecked
  //                             ? Text(
  //                           '${DateFormat('dd/MM/yyyy  kk:mm').format(reminderCheck!.checkedDateTime)}',
  //                           style: Theme.of(context).textTheme.caption!,
  //                         )
  //                             : reminder.label.isNotEmpty
  //                             ? Text(
  //                           '${reminder.label}',
  //                           softWrap: true,
  //                           style: Theme.of(context).textTheme.caption!,
  //                         )
  //                             : Container(),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //       SizedBox(
  //         height: 16,
  //       )
  //     ],
  //   );
  // }
}
