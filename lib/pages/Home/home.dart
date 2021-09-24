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

  //Map timeMap = new Map();
  List timeColumnList = [];


  @override
  Widget build(BuildContext context) {
    final defaultPadding = MediaQuery.of(context).size.width / 20;

    return PageFirstLayout(

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
                title: 'My Pills',
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
                    child: StreamBuilder<List<Reminder>>(
                      stream: widget.reminderDao.findReminderForDayAsStream(
                          _selectedDay.toString(), _selectedDay.weekday),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('error');
                        }
                        if (!snapshot.hasData) return Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 50),
                            child: Text('No Reminders Today', style: TextStyle(color: Colors.black54),),
                          ),
                        );

                        final reminders = snapshot.requireData;

                        if (reminders.isEmpty) return Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 50),
                            child: Text('No Reminders Today', style: TextStyle(color: Colors.black54),),
                          ),
                        );

                        // reminders.sort((a, b) =>
                        //     DateTime(1, 1, 1999, a.dateTime.hour, a.dateTime.minute).compareTo(
                        //         DateTime(1, 1, 1999, b.dateTime.hour, b.dateTime.minute)));
                        //
                        // var newMap = groupBy(reminders, (Reminder reminderItem) =>
                        // '${reminderItem.dateTime.hour < 10? '0': ''}${reminderItem.dateTime.hour}:'
                        // '${reminderItem.dateTime.minute < 10? '0': ''}${reminderItem.dateTime.minute}');
                        //
                        // return Column(
                        //   children: newMap.entries.map((timeGroup) {
                        //     return getTimeGroup(timeGroup);
                        //   }).toList(),
                        // );


                        reminders.sort((a, b) {
                          int cmp = DateTime( 1, 1, 1999, a.dateTime.hour, a.dateTime.minute)
                              .compareTo( DateTime(1, 1, 1999, b.dateTime.hour, b.dateTime.minute));
                          if (cmp != 0) return cmp;
                          return a.medicineName.compareTo(b.medicineName);
                        });

                        timeColumnList.clear();
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: reminders.asMap().entries.map((reminder) {
                            return getReminderRow(reminder.value);
                          }).toList(),
                        );

                      }
                    )
                    // Column(
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

  Row getReminderRow(Reminder reminderItem) {
    var timeLabel = '${reminderItem.dateTime.hour < 10? '0': ''}${reminderItem.dateTime.hour}:'
        '${reminderItem.dateTime.minute < 10? '0': ''}${reminderItem.dateTime.minute}';

    //timeMap.containsKey(time)? timeMap[time]+=1 : timeMap[time] =1;
    //var timeLabel = '';
    timeColumnList.isEmpty ||timeColumnList[0] != timeLabel ? timeColumnList.insert(0, timeLabel): timeLabel ='';
      //timeLabel = time;

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
              Text(timeLabel,
                style: TextStyle(
                    fontSize: 18,
                    color: MyColors.TealBlue,
                    fontWeight: FontWeight.bold),
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
          child: Text('   ${reminderItem.medicineName}',
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600),
          ),
        ),

      ],
    );
  }

  // Row getTimeGroup(MapEntry<String, List<Reminder>> timeGroup) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.start,
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           ConstrainedBox(
  //             constraints: const BoxConstraints(
  //               minWidth: 75,
  //             ),
  //             child:
  //             Text('${timeGroup.key}',
  //               style: TextStyle(
  //                   fontSize: 18,
  //                   color: MyColors.TealBlue,
  //                   fontWeight: FontWeight.bold),
  //             ),
  //
  //           ),
  //           SizedBox(height: 24,),
  //         ],
  //       ),
  //       Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: timeGroup.value.map((
  //             reminderItem) =>
  //             Column(
  //               children: [
  //                 Container(
  //                   decoration: BoxDecoration(
  //                     border: Border(
  //                       left: BorderSide(width: 3.0,
  //                           color: MyColors
  //                               .MiddleBlueGreen),
  //                     ),
  //                     color: Colors.white,
  //                   ),
  //                   child: Text(
  //                     '   ${reminderItem.medicineName}',
  //                     style: TextStyle(
  //                         fontSize: 17,
  //                         fontWeight: FontWeight.w600),
  //                   ),
  //                 ),
  //                 SizedBox(height: 24,),
  //               ],
  //             ),
  //         ).toList(),
  //       )
  //     ],
  //   );
  // }

}
